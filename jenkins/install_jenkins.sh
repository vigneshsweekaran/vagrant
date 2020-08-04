#!/bin/bash

sudo yum -y update && sudo yum -y install wget git maven java-1.8.0-openjdk

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

#Install Ansible
sudo yum -y install epel-release 
sudo yum -y install ansible

#Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y install jenkins
sudo service jenkins start

#Install Gerrit
wget https://gerrit-releases.storage.googleapis.com/gerrit-3.1.3.war
export GERRIT_SITE=~/gerrit_testsite
java -jar gerrit*.war init --batch --dev -d $GERRIT_SITE
sed -i 's/*/172.42.42.105/' ~/gerrit_testsite/etc/gerrit.config
sed -i 's/jenkins/172.42.42.105/' ~/gerrit_testsite/etc/gerrit.config
sed -i 's/8080/8083/' ~/gerrit_testsite/etc/gerrit.config
~/gerrit_testsite/bin/gerrit.sh restart

#Install Artifactory
mkdir -p /jfrog/artifactory/var/
chown -R 1030:1030 /jfrog/artifactory/var/
docker run --name artifactory -v /jfrog/artifactory/var/:/var/opt/jfrog/artifactory -d -p 8081:8081 -p 8082:8082 docker.bintray.io/jfrog/artifactory-oss:latest

#Install SonarQube username/password = admin/admin
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts