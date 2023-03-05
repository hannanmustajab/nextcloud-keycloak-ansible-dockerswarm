FROM alpine:3.17
RUN apk add --no-cache \
    docker-cli \
    jq

COPY entrypoint.sh /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]
