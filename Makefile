#
# Settings
#
ANSIBLE_ARGS :=
ANSIBLE_PLAYBOOK := $(CURDIR)/playbook.yml
VENV_PATH := $(CURDIR)/venv
VENV_ACTIVATE_PATH := $(VENV_PATH)/bin/activate

#
# Ansible
#
.PHONY: ansible-prepare
ansible-prepare: update-venv
	. $(VENV_ACTIVATE_PATH) && ansible-galaxy collection install -r requirements.yml
	. $(VENV_ACTIVATE_PATH) && ansible-galaxy role install -r requirements.yml

.PHONY: run-ansible
run-ansible: ansible-prepare
	. $(VENV_ACTIVATE_PATH) && ansible-playbook \
		--inventory inventory.yml \
		--ssh-common-args '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' \
		--verbose \
		$(ANSIBLE_ARGS) \
		$(ANSIBLE_PLAYBOOK)

.PHONY: run-ansible
run-ansible-lint: update-venv
	. $(VENV_ACTIVATE_PATH) && ansible-lint \
		--format rich \
		--profile production \
		$(ANSIBLE_PLAYBOOK)

.PHONY: add-role
add-role:
ifndef ROLE
	$(error Please set ROLE)
endif
	mkdir -p \
		roles/$(ROLE)/defaults \
		roles/$(ROLE)/files \
		roles/$(ROLE)/handlers \
		roles/$(ROLE)/meta \
		roles/$(ROLE)/tasks \
		roles/$(ROLE)/templates \
		roles/$(ROLE)/vars
	echo '---' > roles/$(ROLE)/defaults/main.yml
	echo '---' > roles/$(ROLE)/handlers/main.yml
	echo '---' > roles/$(ROLE)/meta/main.yml
	echo '---' > roles/$(ROLE)/tasks/main.yml
	echo '---' > roles/$(ROLE)/vars/main.yml

#
# Python
#
venv:
	python3 -m venv $(VENV_PATH)
	$(MAKE) update-venv

.PHONY: update-venv
update-venv: venv
	. $(VENV_ACTIVATE_PATH) && \
	pip install --upgrade pip && \
	pip install -r requirements.txt

#
# VCC
#
VCC_ROLES := \
	nfs \
	docker \
	docker_swarm \
	registry \
	database \
	keycloak \
	nextcloud \
	monitoring \
	logging \
	dashboard

.PHONY: vcc-roles
vcc-roles:
	$(foreach role,$(VCC_ROLES),$(MAKE) add-role ROLE=$(role); )
