#!/usr/bin/env bash
set -e

WORK_DIR=/github/workspace

echo "Set up Jenkins war package."
cd /app/jenkins && jar -cvf jenkins.war *

echo "Download plugins."
java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file ${WORK_DIR}/"$3" --plugin-download-directory=/usr/share/jenkins/ref/plugins

if [ $# == 4 ]
then
    echo "Set up JCasC."
    cp ${WORK_DIR}/"$4" ${CASC_JENKINS_CONFIG}
fi

echo "Running Jenkins pipeline."
/app/bin/jenkinsfile-runner-launcher ${WORK_DIR}/"$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f ${WORK_DIR}/"$2"