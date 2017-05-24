#!/usr/bin/env bash

export INFRASTRUCTURE=local
export DOCKER_REGISTRY=home1oss

# 启动基础环境
export owner_name="rainleon-home1-oss"
export branch_refer="develop"
export git_domain="github.com"


# nexus
export DOCKER_MIRROR_DOMAIN=mirror.docker.${INFRASTRUCTURE}
export DOCKER_REGISTRY_DOMAIN=registry.docker.${INFRASTRUCTURE}
export FILESERVER_DOMAIN=fileserver.${INFRASTRUCTURE}
export INTERNAL_NEXUS=none
export NEXUS_DOMAIN=nexus3.${INFRASTRUCTURE}
export NEXUS_HOSTNAME=nexus3.${INFRASTRUCTURE}


# nexus gitlab jenkins
export NEXUS_PROXY_HOSTNAME=nexus.${INFRASTRUCTURE}
export GIT_HOSTNAME=gitlab.${INFRASTRUCTURE}
export JENKINS_HOSTNAME=jenkins.${INFRASTRUCTURE}
export SONARCUBE_HOSTNAME=sonarqube.${INFRASTRUCTURE}
export RANCHER_SERVER_HOSTNAME=rancher.${INFRASTRUCTURE}
export POSTGRESQL_HOSTNAME=postgresql.${INFRASTRUCTURE}

# 默认端口如下
export JENKINS_PORT=8080
export GIT_PORT=80
export SONARQUBE_PORT=9000
export RANCHER_SERVER_PORT=8080
export NEXUS_PORT=8081
export DOCKER_REGISTRY_PORT=5000
export DOCKER_MIRROR_PORT=5001
export POSTGRESQL_PORT=5432

#first
#docker network create oss-network


declare -A DOCKER_INFRA_LOCAL_DICT

DOCKER_INFRA_LOCAL_DICT["docker-gitlab"]="git@github.com:${owner_name}/docker-gitlab.git gitlab"
DOCKER_INFRA_LOCAL_DICT["docker-jenkins"]="git@github.com:${owner_name}/docker-jenkins.git jenkins"
DOCKER_INFRA_LOCAL_DICT["docker-nexus3"]="git@github.com:${owner_name}/docker-nexus3.git nexus3"
DOCKER_INFRA_LOCAL_DICT["oss-docker"]="git@github.com:${owner_name}/oss-docker.git postgresql rancher"
DOCKER_INFRA_LOCAL_DICT["docker-sonarqube"]="git@github.com:${owner_name}/docker-sonarqube.git ./"

# 启动所有定义好的基础服务
function start_infra_all(){

    mkdir -p oss-docker && rm -rf oss-docker/*

    for infra_name in ${!DOCKER_INFRA_LOCAL_DICT[@]}
    do
        array=(${DOCKER_INFRA_LOCAL_DICT[$infra_name]// / });
        git_clone_url=${array[0]};

        for(( i=1;i<${#array[@]};i++))
        do
            if [ ! -d "oss-docker/${infra_name}" ]; then
                echo "-------------git clone ${infra_name} from ${git_clone_url}-------------"
                (cd oss-docker && git clone ${git_clone_url} && cd ${infra_name} && git checkout ${branch_refer} && git pull);
            fi

            echo "-------------docker-compose operation ${array[i]} @ ${infra_name}-------------"
#            支持子目录，如docker-nexus3下的nexus3在目录 docker-nexus3/nexus3
            if ([ "./" != "${array[i]}" ] && [ -d "oss-docker/${infra_name}/${array[i]}" ]); then
                images=(`(cd oss-docker/${infra_name}/${array[i]} && docker-compose pull)`)
                echo "images pull --------$images"
                if [ -z "${images}" ]; then
                    images=(`(cd oss-docker/${infra_name}/${array[i]} && docker-compose build)`)
                fi
                (cd oss-docker/${infra_name}/${array[i]} && docker-compose stop && docker-compose rm -f && docker-compose up -d)
#                在根目录下的docker-compose文件
            elif ([ "./" == "${array[i]}" ] && [ -f "docker-compose.yml" ]); then
                images=(`(cd oss-docker/${infra_name} && docker-compose pull)`)
                if [ -z "${images}" ]; then
                    images=(`(cd oss-docker/${infra_name}} && docker-compose build)`)
                fi
                (cd oss-docker/${infra_name}/${array[i]} && docker-compose stop && docker-compose rm -f && docker-compose up -d)
            else
                echo "do not contain docker-compose.yml ! skip...  "
            fi

        done
    done
}

# eval "$(curl -s -L ${git_domain}/rainleon/docker-proxy/master/proxy.sh)" \
# 启动代理
function start_proxy(){
    export DOCKER_REGISTRY=registry.docker.${INFRASTRUCTURE}

    docker-compose stop
    docker-compose rm -f
    docker-compose build
    docker-compose up -d
}

function start_infra(){
    echo "-----------start_infra-------"
}


# start_infra_all
# start_proxy

case "$1" in
    "start_infra")
        start_infra_all
        ;;
    "start_proxy")
        start_proxy
        ;;
    "start_infra")
        start_infra
        ;;
    "start_all")
        echo "--------start all infra----------"
        start_infra_all
        echo "--------start proxy----------"
        start_proxy
        ;;
     *)
        echo -e "Usage: proxy.sh param
    param are follows:
        start_infra     start all infra service, include: gitlab,jenkins,sonarqube,nexus3,rancher
        start_proxy     start proxy for all infra
        start_all       start all infra and proxy
        "
        ;;
esac