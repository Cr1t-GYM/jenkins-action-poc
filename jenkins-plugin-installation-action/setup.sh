#!/usr/bin/env bash
set -e

JENKINS_ROOT=./jenkins
JENKINS_VERSION=2.319.3
JENKINS_PM_VERSION=2.5.0
JENKINS_PM_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_PM_VERSION}/jenkins-plugin-manager-${JENKINS_PM_VERSION}.jar
JENKINS_CORE_URL=http://updates.jenkins.io/download/war/${JENKINS_VERSION}/jenkins.war

# download Jenkins core
mkdir -p ${JENKINS_ROOT}
echo "Downloading Jenkins core..."
curl -L ${JENKINS_CORE_URL} -o ${JENKINS_ROOT}/jenkins.war

if [ $# == 1 ]
then
    # download plugin manager
    echo "Downloading plugin manager..."
    wget $JENKINS_PM_URL -O ${JENKINS_ROOT}/jenkins-plugin-manager.jar

    # download plugins
    echo "Downloading plugins..."
    ls -al ${GITHUB_WORKSPACE}
    java -jar ${JENKINS_ROOT}/jenkins-plugin-manager.jar --war ${JENKINS_ROOT}/jenkins.war --plugin-file ${GITHUB_WORKSPACE}/"$1" --plugin-download-directory=${JENKINS_ROOT}/plugins
else
    echo "No plugins downloaded."
fi

echo "Jenkins plugins has been set up."