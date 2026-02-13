FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    socat \
    && rm -rf /var/lib/apt/lists/*

COPY fakefs/ /
COPY start.sh /start.sh
COPY logger.sh /logger.sh

RUN chmod +x /start.sh /logger.sh

EXPOSE 5555

CMD ["/start.sh"]
