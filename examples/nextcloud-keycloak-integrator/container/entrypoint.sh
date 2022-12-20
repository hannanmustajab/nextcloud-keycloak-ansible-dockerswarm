#!/bin/sh
#
# Helper functions
#
# Nextcloud
runOCC() {
    docker exec -i -u www-data "$NEXTCLOUD_CONTAINER_NAME" php occ "$@"
}
setBoolean() { runOCC config:system:set --value="$2" --type=boolean -- "$1"; }
setInteger() { runOCC config:system:set --value="$2" --type=integer -- "$1"; }
setString() { runOCC config:system:set --value="$2" --type=string -- "$1"; }
# Keycloak
runKeycloak() {
    docker exec -i "$KEYCLOAK_CONTAINER_NAME" "$@"
}
keycloakAdminToken() {
    runKeycloak curl -X POST "http://localhost:8080/realms/master/protocol/openid-connect/token" \
        --data-urlencode "username=${KEYCLOAK_ADMIN_USER}" \
        --data-urlencode "password=${KEYCLOAK_ADMIN_PASSWORD}" \
        --data-urlencode 'grant_type=password' \
        --data-urlencode 'client_id=admin-cli'
}
keycloakCurl() {
    runKeycloak curl \
        --header "Authorization: Bearer $(keycloakAdminToken | jq -r '.access_token')" \
        "$@"
}

# Wait until Nextcloud container appears
until docker inspect "$NEXTCLOUD_CONTAINER_NAME"; do
    sleep 1
done
echo 'Nextcloud container found'

# Wait until Keycloak container appears
until docker inspect "$KEYCLOAK_CONTAINER_NAME"; do
    sleep 1
done
echo 'Keycloak container found'

# Wait until Keycloak is alive
until runKeycloak curl -sSf http://127.0.0.1:8080; do
    sleep 1
done
echo 'Keycloak alive'

# Create 'vcc' keycloak realm
if [ "$(keycloakCurl -o /dev/null -sw '%{http_code}' http://127.0.0.1:8080/admin/realms/vcc)" = "404" ]; then
    keycloakCurl \
        -X POST \
        -H 'Content-Type: application/json' \
        --data '{"displayName":"Virtualization and Cloud Computing","id":"vcc","realm":"vcc","enabled":true}' \
        http://127.0.0.1:8080/admin/realms
fi

# Create 'nextcloud' keycloak client
if [ "$(keycloakCurl -o /dev/null -sw '%{http_code}' http://127.0.0.1:8080/admin/realms/vcc/clients/nextcloud)" = "404" ]; then
    # !!! THIS REDIRECT URI IS INSECURE !!!
    keycloakCurl \
        -X POST \
        -H 'Content-Type: application/json; charset=UTF-8' \
        --data "{\"id\":\"nextcloud\",\"clientId\":\"nextcloud\",\"description\":\"Integration with Nextcloud\",\"publicClient\":false,\"redirectUris\":[\"*\"],\"enabled\":true}" \
        http://127.0.0.1:8080/admin/realms/vcc/clients
fi
OIDC_CLIENT_SECRET=$(keycloakCurl http://127.0.0.1:8080/admin/realms/vcc/clients/nextcloud | jq -r '.secret')

# Create a user inside of keycloak
findExaminer() {
    keycloakCurl 'http://127.0.0.1:8080/admin/realms/vcc/users?exact=true&lastName=Examiner'
}
findExaminerId() {
    findExaminer | jq -r '.[0].id'
}
if [ "$(findExaminer | jq -r '. | length')" = "0" ]; then
    keycloakCurl \
        -X POST \
        -H 'Content-Type: application/json; charset=UTF-8' \
        --data "{\"id\":\"examiner\",\"username\":\"vcc-examiner\",\"firstName\":\"VCC\",\"lastName\":\"Examiner\",\"email\":\"vcc.examiner@bots.dibris.unige.it\",\"emailVerified\":true,\"enabled\":true}" \
        http://127.0.0.1:8080/admin/realms/vcc/users
    user_id=$(findExaminerId)
    keycloakCurl \
        -X PUT \
        -H 'Content-Type: application/json; charset=UTF-8' \
        --data "{\"type\":\"rawPassword\",\"value\":\"${SAMPLE_USER_PASSWORD}\"}" \
        "http://127.0.0.1:8080/admin/realms/vcc/users/${user_id}/reset-password"
fi

# Wait until Nextcloud install is complete
until runOCC status --output json_pretty | grep 'installed' | grep -q 'true'; do
    sleep 1
done
echo 'Nextcloud ready'

# Install OpenID Connect login app on Nextcloud
runOCC app:install oidc_login

# Setup OpenID Connect login settings on Nextcloud
setBoolean allow_user_to_change_display_name false
setString lost_password_link disabled
setBoolean oidc_login_disable_registration false

setString oidc_login_provider_url "${OIDC_PROVIDER_URL}"
setString oidc_login_client_id "${OIDC_CLIENT_ID}"
setString oidc_login_client_secret "${OIDC_CLIENT_SECRET}"
setBoolean oidc_login_end_session_redirect true
setString oidc_login_logout_url "${OIDC_LOGOUT_URL}"
setBoolean oidc_login_auto_redirect true
setBoolean oidc_login_redir_fallback true

runOCC config:system:set --value=preferred_username --type=string -- oidc_login_attributes id
runOCC config:system:set --value=email --type=string -- oidc_login_attributes mail