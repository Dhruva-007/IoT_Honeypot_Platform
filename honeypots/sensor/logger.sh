#!/bin/sh

LOG="/telemetry/sensor.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

while true; do
  printf "sensor> "
  IFS= read -r cmd || exit

  [ -z "$(echo "$cmd" | tr -d '[:space:]')" ] && continue

  echo "$(date) CMD: $cmd" >> "$LOG"

  sleep $(awk -v min=0.2 -v max=0.8 'BEGIN{srand(); print min+rand()*(max-min)}')

  case "$cmd" in
    read)
      echo "temperature=$(shuf -i20-40 -n1)C"
      ;;
    *)
      echo "invalid command"
      ;;
  esac
done
