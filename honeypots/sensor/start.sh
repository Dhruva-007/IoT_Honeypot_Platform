#!/bin/sh

echo "[+] Smart Sensor booting..."
echo "Device: TempSense-X"
echo "Firmware: 1.2"

exec socat \
  TCP-LISTEN:1883,reuseaddr,fork \
  EXEC:/logger.sh,pty,stderr,setsid,sigint,sane
