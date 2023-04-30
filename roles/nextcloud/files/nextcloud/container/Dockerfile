FROM nextcloud:23.0-apache
COPY entrypoint_file.sh /entrypoint_file.sh
RUN apt update && apt install -y sudo && apt install -y nano && apt install -y procmail
RUN chmod +x /entrypoint_file.sh

ENTRYPOINT ["/entrypoint_file.sh"]