#!/bin/sh
. /network_profile.sh

LOG="/telemetry/cctv.log"

echo "[SESSION START] id=$(date +%s) time=$(date)" >> $LOG
echo "BusyBox v1.30.1"

while true; do
printf "# "
read cmd || exit
[ -z "$cmd" ] && continue

echo "$(date) CMD: $cmd" >> $LOG

case "$cmd" in

ifconfig)
echo "eth0 inet $CCTV_IP"
;;

"arp -a")
echo "$ROUTER_IP router"
echo "$SENSOR_IP sensor"
echo "$TRAFFIC_IP traffic"
;;

nmap*)
echo "Scanning..."
sleep 1
echo "$ROUTER_IP open telnet"
echo "$SENSOR_IP open mqtt"
echo "$TRAFFIC_IP open control"
;;

ps)
echo "PID CMD"
echo "1 init"
echo "55 camera_daemon"
;;

wget*|curl*)
echo "Connecting..."
sleep 1
echo "Downloaded"
;;

*)
sh -c "$cmd" 2>/dev/null || echo "not found"
;;

esac
done
