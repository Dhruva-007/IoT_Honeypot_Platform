#!/bin/sh
echo "RouterOS RX-$((RANDOM%900+100))"

exec socat TCP-LISTEN:23,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sane,echo=0
