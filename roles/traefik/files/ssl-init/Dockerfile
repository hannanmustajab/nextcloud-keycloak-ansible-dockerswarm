FROM alpine/openssl:latest

RUN apk update

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT /usr/local/bin/entrypoint.sh