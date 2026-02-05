from flask import Flask, jsonify
from flask_cors import CORS
from pathlib import Path
import hashlib

app = Flask(__name__)
CORS(app)

# Unified telemetry sources
LOG_SOURCES = {
    "cctv": Path("../telemetry/cctv.log"),
    "router": Path("../telemetry/router.log"),
    "sensor": Path("../telemetry/sensor.log"),
}

HIGH_RISK = ["wget", "curl", "rm", "busybox", "nc", "chmod"]

def parse_log(device, log_path):
    sessions = []
    current = None

    if not log_path.exists():
        return sessions, 0, 0, set()

    total_cmds = 0
    risky = 0
    unique_cmds = set()

    for line in log_path.read_text().splitlines():

        if "[SESSION START]" in line:
            if current:
                sessions.append(current)

            sid = (
                line.split("id=")[1].split()[0]
                if "id=" in line
                else hashlib.md5(line.encode()).hexdigest()[:8]
            )

            current = {
                "device": device,
                "session_id": sid,
                "start": line,
                "commands": []
            }

        elif "CMD:" in line and current:
            cmd = line.split("CMD:")[1].strip()
            if not cmd:
                continue

            current["commands"].append(cmd)
            total_cmds += 1
            unique_cmds.add(cmd.split()[0])

            if any(r in cmd for r in HIGH_RISK):
                risky += 1

    if current:
        sessions.append(current)

    return sessions, total_cmds, risky, unique_cmds


@app.route("/api/sessions")
def sessions():
    all_sessions = []
    metrics = {
        "total_sessions": 0,
        "total_commands": 0,
        "unique_commands": 0,
        "high_risk_commands": 0,
        "devices": {}
    }

    global_unique_cmds = set()

    for device, path in LOG_SOURCES.items():
        sessions, cmds, risky, unique = parse_log(device, path)

        if sessions:
            metrics["devices"][device] = len(sessions)

        all_sessions.extend(sessions)
        metrics["total_sessions"] += len(sessions)
        metrics["total_commands"] += cmds
        metrics["high_risk_commands"] += risky
        global_unique_cmds.update(unique)

    metrics["unique_commands"] = len(global_unique_cmds)

    return jsonify({
        "metrics": metrics,
        "sessions": all_sessions
    })


@app.after_request
def banner(resp):
    resp.headers["Server"] = "Embedded-IoT-HTTPd/1.0"
    resp.headers["X-Firmware"] = "3.2.1"
    return resp


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
