#!/bin/sh

LOG="/telemetry/cctv.log"
SESSION_ID=$(date +%s)

UPTIME="$((RANDOM%20+5)) days"

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

echo "IP Camera Console"
echo "Linux kernel 3.10.14 (armv7)"
echo "Uptime: $UPTIME"
echo ""

fake_ps() {
echo "PID TTY TIME CMD"
echo "1 ? 00:00 init"
echo "32 ? 00:00 camera_daemon"
echo "58 ? 00:00 rtsp_stream"
}

while true; do
printf "# "
IFS= read -r cmd || exit
[ -z "$cmd" ] && continue

echo "$(date) CMD: $cmd" >> "$LOG"

sleep 0.$((RANDOM%3+2))

case "$cmd" in
uname*)
echo "Linux ipc 3.10.14 armv7l GNU/Linux"
;;
uptime)
echo " $UPTIME"
;;
ps)
fake_ps
;;
ifconfig)
echo "eth0 inet 192.168.1.$((RANDOM%200+20))"
;;
netstat*)
echo "tcp 0 0 0.0.0.0:23 LISTEN"
echo "tcp 0 0 0.0.0.0:554 LISTEN"
;;
wget*)
echo "Connecting..."
sleep 1
echo "Saving to: update.bin"
;;
*)
sh -c "$cmd" 2>/dev/null || echo "sh: command not found"
;;
esac
done
