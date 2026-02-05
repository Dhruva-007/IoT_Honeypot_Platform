#!/bin/sh

LOG="/var/log/router.log"

echo "[+] Router booting..." | tee -a $LOG
echo "Model: RX-2000" | tee -a $LOG
echo "Firmware: 6.45" | tee -a $LOG

exec socat \
  TCP-LISTEN:23,reuseaddr,fork \
  EXEC:/logger.sh,pty,stderr,setsid,sigint,sane
