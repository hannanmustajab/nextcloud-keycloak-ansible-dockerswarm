KEYCLOAK_VERSION := 20.0.1

.PHONY: stop
stop:
	sudo docker rm -f keycloak

.PHONY: run
run:
	sudo docker run -d --name keycloak \
		--network host \
		--restart on-failure \
		-e KEYCLOAK_ADMIN=admin \
		-e KEYCLOAK_ADMIN_PASSWORD=admin \
		-e KC_HOSTNAME=localhost \
		-e KC_DB=postgres \
		-e KC_DB_URL=jdbc:postgresql://localhost/keycloak \
		-e KC_DB_PASSWORD=keycloak \
		-e KC_DB_USERNAME=keycloak \
		quay.io/keycloak/keycloak:$(KEYCLOAK_VERSION) \
			start-dev
