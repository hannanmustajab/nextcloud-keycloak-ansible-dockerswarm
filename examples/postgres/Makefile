POSTGRES_VERSION := 15.1

.PHONY: stop
stop:
	sudo docker rm -f postgres

.PHONY: run
run:
	sudo docker run -d --name postgres \
		--network host \
		--restart on-failure \
		-e POSTGRES_DB=vcc-test \
		-e POSTGRES_USER=vcc-test \
		-e POSTGRES_PASSWORD=vcc-test \
		--tmpfs /var/lib/postgresql/data \
		--volume $(CURDIR)/sql:/docker-entrypoint-initdb.d:ro \
		postgres:$(POSTGRES_VERSION)