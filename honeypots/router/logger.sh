#!/bin/sh
. /network_profile.sh

LOG="/telemetry/router.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

echo "RouterOS Console"
echo "Login successful"

while true; do
printf "Router> "
IFS= read -r cmd || exit
[ -z "$cmd" ] && continue

echo "$(date) CMD: $cmd" >> "$LOG"

sleep 0.$((RANDOM%2+1))

case "$cmd" in
help)
echo "show status | show config | ping | reboot"
;;
"show status")
echo "WAN: connected"
echo "CPU Load: $((RANDOM%40))%"
;;
ping*)
echo "64 bytes from 8.8.8.8 time=20ms"
;;
uname*)
echo "Linux router 4.14.98 mips GNU/Linux"
;;
ps)
echo "init"
echo "routingd"
;;
*)
sh -c "$cmd" 2>/dev/null || echo "Unknown command"
;;
esac
done
