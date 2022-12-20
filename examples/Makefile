.PHONY: stop
stop:
	$(MAKE) -C nextcloud-keycloak-integrator stop
	$(MAKE) -C nextcloud stop
	$(MAKE) -C keycloak stop
	$(MAKE) -C postgres stop

.PHONY: run
run:
	$(MAKE) -C postgres run
	$(MAKE) -C keycloak run
	$(MAKE) -C nextcloud run
	$(MAKE) -C nextcloud-keycloak-integrator run
