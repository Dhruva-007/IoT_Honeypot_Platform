#!/bin/sh

LOG="/telemetry/router.log"

MODEL=$(shuf -n1 -e "EdgeRouter-X" "RX-2000" "TP-Link ER7206")

echo "[BOOT] Router firmware loading..." >> $LOG
sleep 1
echo "[BOOT] Initializing interfaces..." >> $LOG
sleep 1

echo "Router Model: $MODEL" >> $LOG

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sigint,sane,echo=0
