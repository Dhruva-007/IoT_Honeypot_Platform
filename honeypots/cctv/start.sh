#!/bin/sh

LOG=/var/log/telnet.log

echo "[+] Fake CCTV IoT device booting..." >> $LOG

cat << 'EOF' > /bin/logged-shell
#!/bin/sh

LOG=/var/log/telnet.log

echo "============================" >> $LOG
echo "[SESSION START] $(date)" >> $LOG

echo -n "login: "
read USER
echo -n "password: "
read PASS

echo "$(date) LOGIN user=$USER pass=$PASS" >> $LOG
echo "Login successful."

while true; do
  printf "# "
  if ! read cmd; then
    sleep 1
    continue
  fi
  echo "$(date) CMD: $cmd" >> $LOG
  sh -c "$cmd"
done
EOF


chmod +x /bin/logged-shell

# Start telnet daemon in foreground
telnetd -l /bin/logged-shell

sleep infinity
