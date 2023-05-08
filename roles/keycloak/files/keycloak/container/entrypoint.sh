#!/bin/sh

# Wait until postgres is alive
res=1

until [ $res -eq 52 ]; do
    sleep 1
    curl -sSf http://postgres_db:5432
    res=$?
done
echo 'Postgres alive'

/opt/keycloak/bin/kc.sh start-dev --proxy=edge --hostname-url=https://auth.localdomain -Dkeycloak.profile.feature.upload_scripts=enabled -Dkeycloak.migration.strategy=OVERWRITE_EXISTING --import-realm --log-level=trace --log=console,file --log-file=/logs/keycloak.log