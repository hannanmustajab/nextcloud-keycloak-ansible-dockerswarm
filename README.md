# Virtualization and Cloud Computing

Exam project

*Ali Haider(4811831)*, 
*Giacomo Pedemonte(4861715)*, 
*Abdul Hannan Mustajab(5156186)*

# Project Overview

This project aims to set up a multi-node infrastructure with various services using Ansible automation. 

The infrastructure includes two virtual machines, node1 and node2, and involves configuring an NFS share, deploying Docker and Docker Swarm, setting up a Docker registry, using PostgreSQL as a database, implementing a single sign-on (SSO) solution with Keycloak, deploying a Nextcloud service, setting up an external gateway with Traefik, and implementing monitoring and logging with FluentBit, Prometheus, Loki, and Grafana.

## Prerequisites

Before running the Ansible playbook, ensure that the following prerequisites are met:

- Two virtual machines, node1 and node2, are set up and accessible.
- Machines reachable and with updates done.

## Playbook Structure

The Ansible playbook is structured as follows:

1. **Install/Update prerequisites**: This playbook updates the system packages and installs required dependencies on both nodes.
2. **Common part of the playbook for both nodes**: This playbook includes tasks related to configuring NFS, Docker, Docker Swarm, and common logging settings.
3. **Setup local Docker registry for custom images**: This playbook configures a Docker registry on node1, saving files on the NFS share.
4. **Login to local Docker registry with "VCC" user**: This playbook performs authentication and login to the local Docker registry on both nodes.
5. **Database Services**: This playbook deploys PostgreSQL as the database service on node1, storing the data in `/data/postgresql`.
6. **Keycloak Services**: This playbook deploys a Keycloak instance using the "quay.io/keycloak/keycloak:20.0.1" Docker image, with the previously configured database as the backend.
7. **Nextcloud Services**: This playbook deploys a Nextcloud instance using the "nextcloud:23.0-apache" Docker image, persisting the data on NFS at `/data/nextcloud`.
8. **Traefik Services**: This playbook deploys a Traefik instance using the "traefik:v2.9.6" Docker image and configures it as an external gateway for Nextcloud, Keycloak, and Grafana.
9. **Logging services part of the playbook for both nodes**: This playbook deploys FluentBit on each node to handle Docker logs and metrics export.
10. **Grafana services part of the playbook**: This playbook deploys Grafana as a logging and monitoring dashboard, integrating it with Loki and Prometheus.

Please refer to the individual playbooks and roles for more details on the specific tasks performed.

## Configuration and Customization

The playbooks and roles are designed to work with the specified versions of Docker, PostgreSQL, Keycloak, Nextcloud, Traefik, FluentBit, Prometheus, Loki, and Grafana. 
However, you can customize the versions or modify the playbook to suit your specific requirements by editing the corresponding variables in the roles.

## Monitoring and Access
After successfully running the playbook, you can access the deployed services using the following URLs:

Nextcloud: http://cloud.localdomain
Keycloak: http://auth.localdomain
Traefik: http://cloud.localdomain:8081

SSO is enabled.

## Facilities available

- `make run-ansible` runs the Ansible playbook
