#!/bin/sh

LOG="/telemetry/router.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"
echo "Welcome to RouterOS v6.45"
echo "Type 'help' for available commands."

while true; do
  printf "Router> "
  IFS= read -r cmd || exit

  if [ -z "$(echo "$cmd" | tr -d '[:space:]')" ]; then
    continue
  fi

  echo "$(date) CMD: $cmd" >> "$LOG"

  case "$cmd" in
    help)
      echo "Available commands:"
      echo "  show status"
      echo "  show config"
      echo "  reboot"
      echo "  exit"
      ;;
    "show status")
      echo "WAN: connected"
      echo "LAN clients: 5"
      echo "Uptime: 12 days"
      ;;
    "show config")
      echo "admin_password=admin"
      echo "telnet=enabled"
      echo "remote_mgmt=enabled"
      ;;
    reboot)
      echo "Rebooting system..."
      sleep 2
      ;;
    exit|quit)
      echo "Connection closed."
      exit
      ;;
    *)
      echo "Unknown command"
      ;;
  esac
done
