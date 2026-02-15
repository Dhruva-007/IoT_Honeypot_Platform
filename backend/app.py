from flask import Flask, jsonify
from flask_cors import CORS
from pathlib import Path
import re
import uuid
import json
from datetime import datetime, timedelta, timezone
import requests

app = Flask(__name__)
CORS(app)

# -------------------- LOG PATHS --------------------

LOG_DIR = Path("../telemetry")

DEVICE_LOGS = {
    "cctv": LOG_DIR / "cctv.log",
    "router": LOG_DIR / "router.log",
    "sensor": LOG_DIR / "sensor.log",
    "traffic": LOG_DIR / "traffic.log"
}

HIGH_RISK = ["wget", "curl", "nc", "busybox", "chmod", "rm"]

IOC_OUTPUT = LOG_DIR / "iocs.json"
ALERT_OUTPUT = LOG_DIR / "alerts.json"

# -------------------- TIMEZONE (UTC → IST) --------------------

IST = timezone(timedelta(hours=5, minutes=30))

def utc_to_ist_string(utc_string):
    try:
        dt = datetime.fromisoformat(utc_string.replace("Z", ""))
        dt = dt.replace(tzinfo=timezone.utc).astimezone(IST)
        return dt.strftime("%Y-%m-%d %H:%M:%S IST")
    except:
        return utc_string

# -------------------- GEO LOCATION --------------------

geo_cache = {}

def geo_lookup(ip):
    if not ip or ip == "local":
        return {"country": "Local", "city": "-", "isp": "-"}

    if ip in geo_cache:
        return geo_cache[ip]

    try:
        r = requests.get(f"http://ip-api.com/json/{ip}", timeout=2)
        data = r.json()

        result = {
            "country": data.get("country", "Unknown"),
            "city": data.get("city", "Unknown"),
            "isp": data.get("isp", "Unknown")
        }

        geo_cache[ip] = result
        return result
    except:
        return {"country": "Unknown", "city": "-", "isp": "-"}

# -------------------- UTILITIES --------------------

def read_log(path):
    if path.exists():
        return path.read_text().splitlines()
    return []

def extract_ips(line):
    return re.findall(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b', line)

def extract_urls(line):
    return re.findall(r'(https?://[^\s]+)', line)

# -------------------- CORE PARSER --------------------

def parse_all_devices():
    sessions = []

    metrics = {
        "total_sessions": 0,
        "total_commands": 0,
        "unique_commands": set(),
        "high_risk_commands": 0,
        "devices_touched": set()
    }

    iocs = []
    alerts = []

    for device, path in DEVICE_LOGS.items():
        lines = read_log(path)

        current = None
        attacker_ip = "local"

        for line in lines:

            # Capture IP if present
            ips_found = extract_ips(line)
            if ips_found:
                attacker_ip = ips_found[0]

            if "[SESSION START]" in line:
                if current:
                    sessions.append(current)

                geo = geo_lookup(attacker_ip)

                current = {
                    "device": device,
                    "start": line,
                    "commands": [],
                    "ip": attacker_ip,
                    "geo": geo
                }

                metrics["devices_touched"].add(device)

            elif "CMD:" in line and current:
                cmd = line.split("CMD:")[1].strip()
                current["commands"].append(cmd)

                metrics["total_commands"] += 1
                metrics["unique_commands"].add(cmd.split()[0])

                # High risk detection
                if any(r in cmd for r in HIGH_RISK):
                    metrics["high_risk_commands"] += 1
                    alerts.append({
                        "type": "HIGH_RISK_COMMAND",
                        "device": device,
                        "command": cmd,
                        "timestamp": utc_to_ist_string(datetime.utcnow().isoformat())
                    })

                # URL IoC
                for url in extract_urls(cmd):
                    iocs.append({
                        "type": "url",
                        "value": url,
                        "confidence": "high"
                    })

            # IP IoC extraction
            for ip in extract_ips(line):
                iocs.append({
                    "type": "ip",
                    "value": ip,
                    "confidence": "medium"
                })

        if current:
            sessions.append(current)

    # ---------- SCORE CALCULATION ----------

    score = 0

    if metrics["high_risk_commands"] > 0:
        score += 30

    if len(metrics["devices_touched"]) >= 2:
        score += 30
        alerts.append({
            "type": "MULTI_DEVICE_ATTACK",
            "devices": list(metrics["devices_touched"]),
            "timestamp": utc_to_ist_string(datetime.utcnow().isoformat())
        })

    if metrics["total_commands"] >= 5:
        score += 20
        alerts.append({
            "type": "PERSISTENCE_BEHAVIOR",
            "command_count": metrics["total_commands"],
            "timestamp": utc_to_ist_string(datetime.utcnow().isoformat())
        })

    if score >= 60:
        alerts.append({
            "type": "HIGH_THREAT_SCORE",
            "score": score,
            "timestamp": utc_to_ist_string(datetime.utcnow().isoformat())
        })

    metrics["attack_score"] = score
    metrics["total_sessions"] = len(sessions)
    metrics["unique_commands"] = len(metrics["unique_commands"])
    metrics["devices_touched"] = len(metrics["devices_touched"])

    # Save outputs
    IOC_OUTPUT.write_text(json.dumps(iocs, indent=2))
    ALERT_OUTPUT.write_text(json.dumps(alerts, indent=2))

    return metrics, sessions, iocs, alerts

# -------------------- STIX EXPORT --------------------

def generate_stix_bundle(iocs):
    objects = []

    for ioc in iocs:

        if ioc["type"] == "ip":
            pattern = f"[ipv4-addr:value = '{ioc['value']}']"

        elif ioc["type"] == "url":
            pattern = f"[url:value = '{ioc['value']}']"

        else:
            continue

        objects.append({
            "type": "indicator",
            "spec_version": "2.1",
            "id": f"indicator--{uuid.uuid4()}",
            "created": datetime.utcnow().isoformat() + "Z",
            "modified": datetime.utcnow().isoformat() + "Z",
            "name": f"Malicious {ioc['type']}",
            "pattern": pattern,
            "pattern_type": "stix",
            "valid_from": datetime.utcnow().isoformat() + "Z"
        })

    bundle = {
        "type": "bundle",
        "id": f"bundle--{uuid.uuid4()}",
        "objects": objects
    }

    return bundle

# -------------------- API ROUTES --------------------

@app.route("/api/sessions")
def api_sessions():
    metrics, sessions, iocs, alerts = parse_all_devices()
    return jsonify({
        "metrics": metrics,
        "sessions": sessions,
        "ioc_count": len(iocs),
        "alert_count": len(alerts)
    })

@app.route("/api/iocs")
def api_iocs():
    _, _, iocs, _ = parse_all_devices()
    return jsonify(iocs)

@app.route("/api/alerts")
def api_alerts():
    _, _, _, alerts = parse_all_devices()
    return jsonify(alerts)

@app.route("/api/stix")
def api_stix():
    _, _, iocs, _ = parse_all_devices()
    return jsonify(generate_stix_bundle(iocs))

# --------------------

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
