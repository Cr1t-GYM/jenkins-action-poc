#!/usr/bin/env bash
set -e

cd /work
for var in "$@"
do
    echo "$var"
done
echo "Download plugins."
if [ $4 != "true" ]
then
    java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$3" --plugin-download-directory=jenkins_new_plugins
fi
cp -r jenkins_new_plugins /usr/share/jenkins/ref/plugins

if [[ $# == 5 && $5 != "" ]]
then
    echo "Set up JCasC."
    cp "$5" ${CASC_JENKINS_CONFIG}
fi

echo "Running Jenkins pipeline."
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2" --runHome jenkinsHome