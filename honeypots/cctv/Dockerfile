FROM busybox:1.36

# Create fake filesystem like IoT firmware
RUN mkdir -p /bin /etc /proc /tmp /var/log /etc/camera

# Set PATH
ENV PATH=/bin:/sbin:/usr/bin:/usr/sbin

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 23

CMD ["/start.sh"]
