#!/bin/sh
. /network_profile.sh

LOG="/telemetry/sensor.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

echo "Environmental Sensor Ready"

while true; do
printf "sensor$ "
IFS= read -r cmd || exit
[ -z "$cmd" ] && continue

echo "$(date) CMD: $cmd" >> "$LOG"

case "$cmd" in
status)
echo "Temp: $((RANDOM%10+24))C"
echo "Humidity: $((RANDOM%20+50))%"
;;
publish*)
echo "MQTT message delivered."
;;
uname*)
echo "Linux sensor 3.4.11 arm GNU/Linux"
;;
*)
sh -c "$cmd" 2>/dev/null || echo "Invalid command"
;;
esac
done
