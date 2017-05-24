#!/usr/bin/env sh

### environments
NEXUS_DEPLOYMENT_USER="deployment"
if [ -z "${DOCKER_MIRROR_DOMAIN}" ]; then export DOCKER_MIRROR_DOMAIN="mirror.docker.local"; fi
if [ -z "${DOCKER_MIRROR_PORT}" ]; then export DOCKER_MIRROR_PORT=5001; fi
if [ -z "${DOCKER_REGISTRY_DOMAIN}" ]; then export DOCKER_REGISTRY_DOMAIN="registry.docker.local"; fi
if [ -z "${DOCKER_REGISTRY_PORT}" ]; then export DOCKER_REGISTRY_PORT=5000; fi
if [ -z "${FILESERVER_DOMAIN}" ]; then export FILESERVER_DOMAIN="fileserver.local"; fi
if [ -z "${NEXUS_DEPLOYMENT_PASSWORD}" ]; then export NEXUS_DEPLOYMENT_PASSWORD="deployment"; fi
if [ -z "${NEXUS_DOMAIN}" ]; then export NEXUS_DOMAIN="nexus3.local"; fi
if [ -z "${NEXUS_PORT}" ]; then NEXUS_PORT=8081; fi
if [ -z "${NEXUS_PROXY_HOSTNAME}" ]; then export NEXUS_PROXY_HOSTNAME="nexus.local"; fi

if [ -z "${GIT_HOSTNAME}" ]; then export GIT_HOSTNAME="gitlab.local"; fi
if [ -z "${GIT_PORT}" ]; then export GIT_PORT=80; fi
if [ -z "${JENKINS_HOSTNAME}" ]; then export JENKINS_HOSTNAME="jenkins.local"; fi
if [ -z "${JENKINS_PORT}" ]; then export JENKINS_PORT=8080; fi
if [ -z "${SONARCUBE_HOSTNAME}" ]; then export SONARCUBE_HOSTNAME="sonarqube.local"; fi
if [ -z "${SONARQUBE_PORT}" ]; then export SONARQUBE_PORT=9000; fi
if [ -z "${RANCHER_SERVER_HOSTNAME}" ]; then export RANCHER_SERVER_HOSTNAME="rancher.local"; fi
if [ -z "${RANCHER_SERVER_PORT}" ]; then export RANCHER_SERVER_PORT=8080; fi

### vars
NEXUS_DEPLOYMENT_AUTH_HEADER="'Basic $(echo -ne "${NEXUS_DEPLOYMENT_USER}:${NEXUS_DEPLOYMENT_PASSWORD}" | base64)'"

if [ ! -z "${NEXUS_CONTEXT}" ]; then
    SED_FILESERVER_PATH="s#FILESERVER_PATH#${NEXUS_CONTEXT}/repository/files#"
else
    SED_FILESERVER_PATH="s#FILESERVER_PATH#repository/files#"
fi

target_directory="$1"
sed "s/DOCKER_MIRROR_DOMAIN/${DOCKER_MIRROR_DOMAIN}/; s/DOCKER_MIRROR_URL/${DOCKER_MIRROR_DOMAIN}:${DOCKER_MIRROR_PORT}/;" nexus_docker.conf_tpl | \
    sed "s/DOCKER_REGISTRY_DOMAIN/${DOCKER_REGISTRY_DOMAIN}/; s/DOCKER_REGISTRY_URL/${DOCKER_REGISTRY_DOMAIN}:${DOCKER_REGISTRY_PORT}/;" | \
    sed "s/GITLAB_DOMAIN/${GIT_HOSTNAME}/; s/GITLAB_URL/${GIT_HOSTNAME}:${GIT_PORT}/;" | \
    sed "s/JENKINS_DOMAIN/${JENKINS_HOSTNAME}/; s/JENKINS_URL/${JENKINS_HOSTNAME}:${JENKINS_PORT}/;" | \
    sed "s/SONARQUBE_DOMAIN/${SONARCUBE_HOSTNAME}/; s/SONARQUBE_URL/${SONARCUBE_HOSTNAME}:${SONARQUBE_PORT}/;" | \
    sed "s/RANCHER_DOMAIN/${RANCHER_SERVER_HOSTNAME}/; s/RANCHER_URL/${RANCHER_SERVER_HOSTNAME}:${RANCHER_SERVER_PORT}/;" | \
    sed "s/NEXUS_PROXY_HOSTNAME/${NEXUS_PROXY_HOSTNAME}/; s/NEXUS_URL/${NEXUS_DOMAIN}:${NEXUS_PORT}/;" | \
    sed "${SED_FILESERVER_PATH}; s#FILESERVER_DOMAIN#${FILESERVER_DOMAIN}#; s###" | \
    sed "s#_NEXUS_DEPLOYMENT_AUTH#${NEXUS_DEPLOYMENT_AUTH_HEADER}#" > ${target_directory}/nexus_docker.conf
