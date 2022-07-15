#!/usr/bin/env bash
set -e

if [[ $# -lt 2 && $# -ge 4 ]]
then
    echo "Invalid parameters."
    exit 1
fi

if [ $# == 3 ]
then
    echo "Set up JCasC."
    cp "$3" "${CASC_JENKINS_CONFIG}"
fi

echo "Running Jenkins pipeline."
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2" --runHome /jenkinsHome --withInitHooks demo/javascript/my-react-app/init.groovy
echo "The pipeline log is available at /jenkinsHome/jobs/job/builds!"