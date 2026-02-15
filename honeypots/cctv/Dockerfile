FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    socat \
    python3 \
    net-tools \
    iproute2 \
    iputils-ping \
    curl \
    wget \
    netcat \
    busybox \
    coreutils \
    procps \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
COPY logger.sh /logger.sh
COPY network_profile.sh /network_profile.sh

RUN chmod +x /start.sh /logger.sh /network_profile.sh

EXPOSE 23 80 554 8443

CMD ["/start.sh"]
