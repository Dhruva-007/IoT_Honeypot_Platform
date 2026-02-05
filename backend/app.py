from flask import Flask, jsonify
from flask_cors import CORS
from pathlib import Path

app = Flask(__name__)
CORS(app)  # <-- THIS IS THE FIX

TELNET_LOG = Path("../telemetry/telnet.log")

HIGH_RISK = ["wget", "curl", "rm", "busybox", "nc", "chmod"]

def parse_telnet():
    sessions = []
    total_cmds = 0
    risky = 0
    unique_cmds = set()

    if not TELNET_LOG.exists():
        return {
            "total_sessions": 0,
            "total_commands": 0,
            "unique_commands": 0,
            "high_risk_commands": 0
        }, []

    current = None

    for line in TELNET_LOG.read_text().splitlines():
        if "[SESSION START]" in line:
            if current:
                sessions.append(current)
            current = {"start": line, "commands": []}

        elif "CMD:" in line and current:
            cmd = line.split("CMD:")[1].strip()
            current["commands"].append(cmd)

            total_cmds += 1
            unique_cmds.add(cmd.split()[0])

            if any(r in cmd for r in HIGH_RISK):
                risky += 1

    if current:
        sessions.append(current)

    metrics = {
        "total_sessions": len(sessions),
        "total_commands": total_cmds,
        "unique_commands": len(unique_cmds),
        "high_risk_commands": risky
    }

    return metrics, sessions


@app.route("/api/sessions")
def sessions():
    metrics, data = parse_telnet()
    return jsonify({
        "metrics": metrics,
        "sessions": data
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
