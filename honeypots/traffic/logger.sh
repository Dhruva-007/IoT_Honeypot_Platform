#!/bin/sh

LOG="/telemetry/traffic.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

echo "Traffic Control Console"

while true; do
printf "traffic# "
IFS= read -r cmd || exit
[ -z "$cmd" ] && continue

echo "$(date) CMD: $cmd" >> "$LOG"

case "$cmd" in
status)
echo "Signal Mode: AUTO"
echo "Cycle: 80 seconds"
;;
override*)
echo "Manual override enabled."
;;
logs)
echo "Last sync: $(date)"
;;
uname*)
echo "Linux traffic 2.6.32 arm GNU/Linux"
;;
*)
sh -c "$cmd" 2>/dev/null || echo "Command not recognized"
;;
esac
done
