#!/bin/sh

LOG="/telemetry/traffic.log"

DEVICE_ID=$(head -c 6 /dev/urandom | od -An -tx1 | tr -d ' \n')

echo "[+] Traffic Controller ID:$DEVICE_ID" >> "$LOG"

(
  while true; do
    echo "$(date) INFO: signal sync OK" >> "$LOG"
    sleep 80
  done
) &

exec socat TCP-LISTEN:5555,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane
