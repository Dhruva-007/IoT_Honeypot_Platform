#!/bin/sh
echo "TrafficControl TCU-$((RANDOM%900+100))"

exec socat TCP-LISTEN:5555,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sane,echo=0
