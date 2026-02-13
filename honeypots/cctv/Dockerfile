FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    socat \
    python3 \
    && rm -rf /var/lib/apt/lists/*

COPY fakefs/ /
COPY start.sh /start.sh
COPY logger.sh /logger.sh

RUN chmod +x /start.sh /logger.sh

EXPOSE 23 80 554 8443

CMD ["/start.sh"]
