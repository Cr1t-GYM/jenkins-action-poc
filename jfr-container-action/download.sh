#!/usr/bin/env bash
set -e

mkdir -p ${GITHUB_WORKSPACE}/jenkins_new_plugins
if [ $# == 1 ]
then 
    echo "Download plugins."
    java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$1" --plugin-download-directory=${GITHUB_WORKSPACE}/jenkins_new_plugins
    cp -r ${GITHUB_WORKSPACE}/jenkins_new_plugins/* /usr/share/jenkins/ref/plugins
else
    echo "No plugins downloaded."
fi