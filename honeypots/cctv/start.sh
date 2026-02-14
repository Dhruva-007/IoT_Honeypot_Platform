#!/bin/sh

LOG="/telemetry/cctv.log"

MODEL="IPC-$((RANDOM%9000+1000))"

echo "[BOOT] IPCamera $MODEL" >> $LOG

# Fake services
python3 -m http.server 80 >/dev/null 2>&1 &
socat TCP-LISTEN:554,fork EXEC:'/bin/cat' &
socat TCP-LISTEN:8443,fork EXEC:'/bin/cat' &

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sane,echo=0
