#!/bin/sh

LOG="/telemetry/cctv.log"

DEVICE_ID=$(head -c 6 /dev/urandom | od -An -tx1 | tr -d ' \n')

MODEL=$(shuf -n1 <<EOF
IPC-3200
IPC-4200
CamX-Pro
EOF
)

FW=$(shuf -n1 <<EOF
v3.2.1
v3.1.9
v3.0.8
EOF
)

{
  echo "[+] IPCam Booting..."
  echo "Model: $MODEL"
  echo "Firmware: $FW"
  echo "DeviceID: $DEVICE_ID"
} >> "$LOG"

# Background heartbeat noise
(
  while true; do
    echo "$(date) INFO: heartbeat OK" >> "$LOG"
    sleep 60
  done
) &

# Fake Web UI
cd /var/www 2>/dev/null || mkdir -p /var/www
echo "<html><body><h1>$MODEL</h1></body></html>" > /var/www/index.html
python3 -m http.server 80 >/dev/null 2>&1 &

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane
