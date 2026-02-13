#!/bin/sh

LOG="/telemetry/cctv.log"

MODEL=$(shuf -n1 -e "HikVision DS-2CD2143G0" "Dahua IPC-HDW5231" "IPC-3200")
FW=$(shuf -n1 -e "v3.2.1" "v4.0.2" "v3.8.5")

echo "[BOOT] Initializing camera firmware..." >> $LOG
sleep 1
echo "[BOOT] Loading drivers..." >> $LOG
sleep 1
echo "[BOOT] Starting video daemon..." >> $LOG
sleep 1

echo "Model: $MODEL" >> $LOG
echo "Firmware: $FW" >> $LOG

mkdir -p /var/run/camera
touch /var/run/camera.pid

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane,echo=0
