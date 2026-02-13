#!/bin/sh

LOG="/telemetry/traffic.log"

MODEL=$(shuf -n1 -e "TCU-500" "Siemens Sitraffic" "UrbanFlow-X")

echo "[BOOT] Traffic controller startup..." >> $LOG
sleep 1
echo "Controller: $MODEL" >> $LOG

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane,echo=0
