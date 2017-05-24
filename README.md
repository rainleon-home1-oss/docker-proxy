# docker-proxy
用来在本地代理启动的全部基础服务，包括:nexus3,gitlab,jenkins,sonarqube,rancher.消除本地请求url地址中的端口.

启动代理前请确保所有的环境已经ready,否则代理无法成功启动。

## 启动本地基础服务

    mkdir oss-ws
    (mkdir -p oss-ws/gitlab &&\
        cd oss-ws/gitlab &&\
        curl -o docker-compose.yml https://raw.githubusercontent.com/rainleon-home1-oss/docker-gitlab/develop/gitlab/docker-compose.yml &&\
        eval "$(curl -s -L https://raw.githubusercontent.com/home1-oss/docker-proxy/master/proxy.sh)"\
    )


## 启动代理

    cd docker-proxy
    sh ./proxy.sh

## 使用脚本启动本地基础服务
在基础服务的docker-compose.yml所在目录下，执行(如，cd docker-gitlab/gitlab)

    eval "$(curl -s -L https://raw.githubusercontent.com/home1-oss/docker-proxy/master/proxy.sh)"


## 验证服务

- [nexus](http://nexus.local/nexus)
- [jenkins](http://jenkins.local)
- [gitlab](http://gitlab.local)
- [sonarqube](http://sonarqube.local)
- [rancher](http://rancher.local)



