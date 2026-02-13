#!/bin/sh

LOG="/telemetry/sensor.log"

DEVICE_ID=$(head -c 6 /dev/urandom | od -An -tx1 | tr -d ' \n')

echo "[+] Sensor Online ID:$DEVICE_ID" >> "$LOG"

(
  while true; do
    echo "$(date) INFO: sensor heartbeat OK" >> "$LOG"
    sleep 90
  done
) &

exec socat TCP-LISTEN:1883,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane
