#!/usr/bin/env bash

export INFRASTRUCTURE=local

# nexus
export DOCKER_MIRROR_DOMAIN=mirror.docker.${INFRASTRUCTURE}
export DOCKER_REGISTRY_DOMAIN=registry.docker.${INFRASTRUCTURE}
export FILESERVER_DOMAIN=fileserver.${INFRASTRUCTURE}
export INTERNAL_NEXUS=none
export NEXUS_DOMAIN=nexus3.${INFRASTRUCTURE}
export NEXUS_HOSTNAME=nexus3.${INFRASTRUCTURE}

export NEXUS_PROXY_HOSTNAME=nexus.${INFRASTRUCTURE}
# gitlab
export GIT_HOSTNAME=gitlab.${INFRASTRUCTURE}
export JENKINS_HOSTNAME=jenkins.${INFRASTRUCTURE}
export SONARCUBE_HOSTNAME=sonarqube.${INFRASTRUCTURE}
export RANCHER_SERVER_HOSTNAME=rancher.${INFRASTRUCTURE}
export DOCKER_REGISTRY=registry.docker.${INFRASTRUCTURE}

#first 
#docker network create oss-network

docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose up -d

