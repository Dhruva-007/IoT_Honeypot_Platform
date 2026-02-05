#!/bin/sh

LOG="/telemetry/sensor.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"
echo "SensorNode v1.2 Ready"
echo "Commands: READ, STATUS, SET MODE, EXIT"

MODE="NORMAL"

while true; do
  printf "sensor> "
  IFS= read -r cmd || exit

  if [ -z "$(echo "$cmd" | tr -d '[:space:]')" ]; then
    continue
  fi

  echo "$(date) CMD: $cmd" >> "$LOG"

  case "$cmd" in
    READ)
      echo "temperature=26.4C"
      echo "humidity=61%"
      ;;
    STATUS)
      echo "mode=$MODE"
      echo "uptime=7200s"
      ;;
    "SET MODE ATTACK")
      MODE="ATTACK"
      echo "mode changed"
      ;;
    EXIT)
      echo "disconnecting"
      exit
      ;;
    *)
      echo "invalid command"
      ;;
  esac
done
