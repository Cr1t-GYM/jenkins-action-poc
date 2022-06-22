#!/usr/bin/env bash
set -e

if [ $# == 3 ]
then
    echo "Set up JCasC."
    cp "$3" ${CASC_JENKINS_CONFIG}
fi

echo "Running Jenkins pipeline."
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2"