#!/usr/bin/env bash
set -e

echo "Download plugins."
ls -al /usr/share/jenkins/ref/plugins
java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$3" --plugin-download-directory=/usr/share/jenkins/ref/plugins
ls -al /usr/share/jenkins/ref/plugins

if [[ $# == 4 && $4 != "" ]]
then
    echo "Set up JCasC."
    cp "$4" ${CASC_JENKINS_CONFIG}
fi

echo "Running Jenkins pipeline."
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2"