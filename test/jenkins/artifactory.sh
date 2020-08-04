#!/bin/bash

sudo yum -y update && sudo yum -y install wget git java-1.8.0-openjdk

#Install Docker
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker vagrant
newgrp docker

mkdir -p /jfrog/artifactory/var/
chown -R 1030:1030 /jfrog/artifactory/var/
docker run --name artifactory -v /jfrog/artifactory/var/:/var/opt/jfrog/artifactory -d -p 8081:8081 -p 8082:8082 docker.bintray.io/jfrog/artifactory-oss:latest