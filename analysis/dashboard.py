import re
from collections import defaultdict
from datetime import datetime

LOG = "telemetry/telnet.log"
OUT = "dashboard/index.html"

sessions = defaultdict(list)
current = None

with open(LOG) as f:
    for line in f:
        if "[SESSION START]" in line:
            m = re.search(r"id=(\d+)", line)
            if m:
                current = m.group(1)
        elif "CMD:" in line and current:
            sessions[current].append(line.strip())

total_sessions = len(sessions)
total_cmds = sum(len(v) for v in sessions.values())

rows = ""
for sid, cmds in sessions.items():
    rows += f"<tr><td>{sid}</td><td>{len(cmds)}</td></tr>\n"

html = f"""
<html>
<head>
<title>IoT Honeypot Dashboard</title>
<style>
body {{ font-family: Arial; }}
table {{ border-collapse: collapse; }}
td, th {{ border: 1px solid #444; padding: 8px; }}
</style>
</head>
<body>
<h1>IoT Honeypot Metrics</h1>
<p><b>Total Sessions:</b> {total_sessions}</p>
<p><b>Total Commands:</b> {total_cmds}</p>

<table>
<tr><th>Session ID</th><th>Command Count</th></tr>
{rows}
</table>

<p>Last updated: {datetime.utcnow()} UTC</p>
</body>
</html>
"""

with open(OUT, "w") as f:
    f.write(html)

print("Dashboard generated:", OUT)
