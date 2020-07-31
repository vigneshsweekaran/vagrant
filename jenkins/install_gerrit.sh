#!/bin/bash

wget https://gerrit-releases.storage.googleapis.com/gerrit-3.1.3.war
export GERRIT_SITE=~/gerrit_testsite
java -jar gerrit*.war init --batch --dev -d $GERRIT_SITE
sed -i 's/*/172.42.42.105/' ~/gerrit_testsite/etc/gerrit.config
sed -i 's/jenkins/172.42.42.105/' ~/gerrit_testsite/etc/gerrit.config
sed -i 's/8080/8081/' ~/gerrit_testsite/etc/gerrit.config
~/gerrit_testsite/bin/gerrit.sh restart