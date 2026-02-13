#!/bin/sh

LOG="/telemetry/sensor.log"

MODEL=$(shuf -n1 -e "EnvSense-X1" "AQNode-200" "SmartProbe")

echo "[BOOT] Sensor initializing..." >> $LOG
sleep 1
echo "Device: $MODEL" >> $LOG

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane,echo=0
