.PHONY: stop
stop:
	sudo docker rm -f nextcloud-keycloak-integrator

.PHONY: build
build:
	sudo docker build -t nextcloud-keycloak-integrator container

.PHONY: run
run: build
	sudo docker run -d --name nextcloud-keycloak-integrator \
		--network host \
		--restart on-failure \
		-e NEXTCLOUD_CONTAINER_NAME=nextcloud \
		-e KEYCLOAK_CONTAINER_NAME=keycloak \
		-e KEYCLOAK_ADMIN_USER=admin \
		-e KEYCLOAK_ADMIN_PASSWORD=admin \
		-e SAMPLE_USER_PASSWORD=itsdifficult \
		-e OIDC_CLIENT_ID=nextcloud \
		-e OIDC_PROVIDER_URL=http://localhost:8080/realms/vcc \
		-e OIDC_LOGOUT_URL=http://localhost/apps/oidc_login/oidc \
		-v /var/run/docker.sock:/var/run/docker.sock \
		nextcloud-keycloak-integrator