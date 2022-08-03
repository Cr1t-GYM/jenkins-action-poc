#!/usr/bin/env bash
set -euo pipefail

echo "Download plugins."
java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$3" --plugin-download-directory=/usr/share/jenkins/ref/plugins

if [[ $# == 4 && $4 != "" ]]
then
    echo "Set up JCasC."
    cp "$4" "${CASC_JENKINS_CONFIG}"
fi

echo "Running Jenkins pipeline."
mkdir -p jenkinsHome
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2" --runHome jenkinsHome --withInitHooks /app/jenkins/WEB-INF/groovy.init.d
echo "The pipeline log is available at jenkinsHome/jobs/job/builds"
