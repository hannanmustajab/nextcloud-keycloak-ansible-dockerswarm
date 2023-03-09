#!/bin/sh
test -z $SSL_CN && SSL_CN="localhost"
test -z $SSL_O && SSL_O="VCC"
test -z $SSL_C && SSL_C="IT"
test -z $SSL_DAYS && SSL_DAYS=3650

if [ ! -e /ssl/server.key ]; then
    echo "Generating self-signed certificate"
    openssl req -subj "/CN=$SSL_CN/O=$SSL_O/C=$SSL_C" \
     -new -newkey rsa:2048 -days $SSL_DAYS -nodes -x509 -keyout /etc/ssl/traefik/server.key \
     -out /etc/ssl/traefik/server.crt

echo "
tls:
  stores:
    default:
      defaultCertificate:
        certFile: /etc/ssl/traefik/server.crt
        keyFile: /etc/ssl/traefik/server.key
  certificates:
    - certFile: /etc/ssl/traefik/server.crt
      keyFile: /etc/ssl/traefik/server.key
" > /etc/traefik/dynamic/certs-traefik.yml 
fi