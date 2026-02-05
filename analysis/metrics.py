from collections import defaultdict
import re

logfile = "telemetry/telnet.log"

sessions = defaultdict(list)
current = None

with open(logfile) as f:
    for line in f:
        if "[SESSION START]" in line:
            m = re.search(r"id=(\d+)", line)
            if m:
                current = m.group(1)
        elif "CMD:" in line and current:
            sessions[current].append(line.strip())

print(f"Total sessions: {len(sessions)}")
for sid, cmds in sessions.items():
    print(f"Session {sid}: {len(cmds)} commands")
