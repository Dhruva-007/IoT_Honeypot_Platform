#!/bin/sh

LOG="/telemetry/router.log"

DEVICE_ID=$(head -c 6 /dev/urandom | od -An -tx1 | tr -d ' \n')

MODEL=$(shuf -n1 <<EOF
RX-2000
EdgeRoute-X
NetCore-AC
EOF
)

FW=$(shuf -n1 <<EOF
6.45
6.48.1
6.44
EOF
)

{
  echo "[+] Router Boot"
  echo "Model: $MODEL"
  echo "Firmware: $FW"
  echo "DeviceID: $DEVICE_ID"
} >> "$LOG"

(
  while true; do
    echo "$(date) INFO: route check OK" >> "$LOG"
    sleep 75
  done
) &

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane
