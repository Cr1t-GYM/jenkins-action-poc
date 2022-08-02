#!/usr/bin/env bash
set -e

JENKINS_ROOT=./jenkins
JENKINS_VERSION=2.319.3
JENKINS_PM_VERSION=2.5.0
JFR_VERSION=1.0-beta-30

if [ $# == 1 ]
then
    JENKINS_VERSION = $1
fi

JENKINS_PM_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_PM_VERSION}/jenkins-plugin-manager-${JENKINS_PM_VERSION}.jar
JENKINS_CORE_URL=http://updates.jenkins.io/download/war/${JENKINS_VERSION}/jenkins.war
JENKINS_JFR_URL=https://github.com/jenkinsci/jenkinsfile-runner/releases/download/${JFR_VERSION}/jenkinsfile-runner-${JFR_VERSION}.zip

# download Jenkins core
mkdir -p ${JENKINS_ROOT}
echo "Downloading Jenkins $JENKINS_VERSION core..."
curl -L ${JENKINS_CORE_URL} -o ${JENKINS_ROOT}/jenkins.war
# download Jenkinsfile-runner
echo "Downloading Jenkinsfile runner..."
curl -L ${JENKINS_JFR_URL} -o ${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}.zip
unzip -q ${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}.zip -d ${JENKINS_ROOT}/jenkinsfile-runner
chmod +x ${JENKINS_ROOT}/jenkinsfile-runner/bin/jenkinsfile-runner
mkdir -p ${GITHUB_WORKSPACE}/jenkins/casc
unzip -q ${JENKINS_ROOT}/jenkins.war -d ${JENKINS_ROOT}/jenkins
# download plugin manager
echo "Downloading Jenkins plugin manager..."
curl -L $JENKINS_PM_URL -o ${JENKINS_ROOT}/jenkins-plugin-manager.jar
echo "Downloading latest minimum required plugins for pipeline..."
java -jar ${JENKINS_ROOT}/jenkins-plugin-manager.jar --war ${JENKINS_ROOT}/jenkins.war --plugin-file ${GITHUB_ACTION_PATH}/plugins.txt --plugin-download-directory=${JENKINS_ROOT}/plugins

echo "Jenkins environment has been set up..."