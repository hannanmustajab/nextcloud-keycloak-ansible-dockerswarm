NEXTCLOUD_VERSION := 23.0-apache

.PHONY: stop
stop:
	sudo docker rm -f nextcloud

.PHONY: run
run:
	sudo docker run -d --name nextcloud \
		--network host \
		--restart on-failure \
		-e POSTGRES_DB=nextcloud \
		-e POSTGRES_USER=nextcloud \
		-e POSTGRES_PASSWORD=nextcloud \
		-e POSTGRES_HOST=127.0.0.1 \
		-e NEXTCLOUD_ADMIN_USER=admin \
		-e NEXTCLOUD_ADMIN_PASSWORD=admin \
		nextcloud:$(NEXTCLOUD_VERSION)
