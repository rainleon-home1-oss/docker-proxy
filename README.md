# docker-proxy
用来在本地代理启动的全部基础服务，包括:nexus3,gitlab,jenkins,sonarqube,rancher.消除本地请求url地址中的端口.

## 启动本地基础服务

    bash <(curl -s -L https://raw.githubusercontent.com/home1-oss/docker-proxy/master/proxy.sh) start_infra_all

## 启动代理

    bash <(curl -s -L https://raw.githubusercontent.com/home1-oss/docker-proxy/master/proxy.sh) start_proxy

## 一键启动所有服务[推荐]

    bash <(curl -s -L https://raw.githubusercontent.com/home1-oss/docker-proxy/master/proxy.sh) start_all


## 验证服务
配置hosts文件，增加如下内容:

    127.0.0.1	 rancher.local
    127.0.0.1	 gitlab.local
    127.0.0.1	 nexus.local
    127.0.0.1    registry.docker.local
    127.0.0.1    mirror.docker.local
    127.0.0.1    fileserver.local
    127.0.0.1    jenkins.local
    127.0.0.1    sonarqube.local

逐个验证服务

- [nexus](http://nexus.local/nexus)
- [jenkins](http://jenkins.local)
- [gitlab](http://gitlab.local)
- [sonarqube](http://sonarqube.local)
- [rancher](http://rancher.local)



