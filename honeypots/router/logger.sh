#!/bin/sh

LOG="/telemetry/router.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

while true; do
  printf "Router> "
  IFS= read -r cmd || exit

  [ -z "$(echo "$cmd" | tr -d '[:space:]')" ] && continue

  echo "$(date) CMD: $cmd" >> "$LOG"

  sleep $(awk -v min=0.2 -v max=0.8 'BEGIN{srand(); print min+rand()*(max-min)}')

  case "$cmd" in
    ps)
      echo "init watchdog telnetd"
      ;;
    show*)
      echo "WAN: connected"
      ;;
    uname*)
      echo "RouterOS Embedded Kernel"
      ;;
    *)
      echo "unknown command"
      ;;
  esac
done
