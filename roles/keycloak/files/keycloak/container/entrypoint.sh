#!/bin/sh

# Wait until postgres is alive
res=1

until [ $res -eq 52 ]; do
    sleep 1
    curl -sSf http://postgres_db:5432
    res=$?
done
echo 'Postgres alive'

/opt/keycloak/bin/kc.sh start-dev -Dkeycloak.profile.feature.upload_scripts=enabled -Dkeycloak.migration.strategy=OVERWRITE_EXISTING --import-realm --log-level=info --log=console,file --log-file=/logs/keycloak.log --hostname=auth.localdomain --hostname-strict-https=false