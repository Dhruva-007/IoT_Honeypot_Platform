FROM ubuntu:20.04

RUN apt-get update && apt-get install -y socat

COPY start.sh /start.sh
COPY logger.sh /logger.sh
COPY network_profile.sh /network_profile.sh

RUN chmod +x /start.sh /logger.sh /network_profile.sh

EXPOSE 5555

CMD ["/start.sh"]
