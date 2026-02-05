#!/bin/sh

LOG="/var/log/telnet.log"

# ---------------- BOOT BANNER ----------------
echo "[+] IPCam Booting..." | tee -a $LOG
echo "Model: IPC-3200" | tee -a $LOG
echo "Firmware: v3.2.1" | tee -a $LOG
echo "Linux kernel 3.10.14" | tee -a $LOG
echo "[SESSION START] id=$(date +%s) time=$(date)" >> $LOG

# ---------------- FAKE FILESYSTEM ----------------
mkdir -p /etc/camera /var/log/camera /www

echo "admin:admin123" > /etc/camera/users.conf
echo "rtsp://0.0.0.0/live" > /etc/camera/stream.conf
echo "Camera OK" > /var/log/camera/status.log

# ---------------- FAKE WEB UI ----------------
cd /www
echo "<html><body><h1>IP Camera Web Interface</h1></body></html>" > index.html
python3 -m http.server 80 >/dev/null 2>&1 &

# ---------------- TELNET HONEYPOT (SOCAT) ----------------
# This is rock-solid in Docker
# Looks like Telnet, gives /bin/sh, never exits

exec socat \
  TCP-LISTEN:23,reuseaddr,fork \
  EXEC:/logger.sh,pty,stderr,setsid,sigint,sane

