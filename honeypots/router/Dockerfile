FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    socat \
    procps \
    && rm -rf /var/lib/apt/lists/*

COPY logger.sh /logger.sh
RUN chmod +x /logger.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 23

CMD ["/start.sh"]
