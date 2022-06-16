#!/usr/bin/env bash
set -e

JENKINS_ROOT=/jenkins
JENKINS_VERSION=2.319.3
JENKINS_PM_VERSION=2.5.0
JENKINS_PM_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_PM_VERSION}/jenkins-plugin-manager-${JENKINS_PM_VERSION}.jar

# download Jenkins core
echo "Downloading Jenkins core..."
curl -L http://updates.jenkins.io/download/war/${JENKINS_VERSION}/jenkins.war -o ${JENKINS_ROOT}/jenkins.war

if [$# = 1]
    # download plugin manager
    echo "Downloading plugin manager..."
    wget $JENKINS_PM_URL -O ${JENKINS_ROOT}/jenkins-plugin-manager.jar

    # download plugins
    echo "Downloading plugins..."
    ls -al /github/workspace
    java -jar ${JENKINS_ROOT}/jenkins-plugin-manager.jar --war jenkins.war --plugin-file ${GITHUB_WORKSPACE}"$1" --plugin-download-directory=${JENKINS_ROOT}/plugins
then
else
    echo "No plugins downloaded."
fi

echo "Jenkins plugins has been set up."