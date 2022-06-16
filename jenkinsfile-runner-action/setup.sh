#!/usr/bin/env bash
set -e

JENKINS_ROOT=./jenkins
JFR_VERSION=1.0-beta-30
JENKINS_JFR_URL=https://github.com/jenkinsci/jenkinsfile-runner/releases/download/${JFR_VERSION}/jenkinsfile-runner-${JFR_VERSION}.zip

echo "Downloading Jenkinsfile-runner"
curl -L ${JENKINS_JFR_URL} -o ${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}.zip
unzip ${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}.zip -d ${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}
chmod +x ${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}/bin/jenkinsfile-runner
mkdir -p ${GITHUB_WORKSPACE}/jenkins/casc

if [ $# == 3 ]
then
    cp ${GITHUB_WORKSPACE}/$3 ${GITHUB_WORKSPACE}/jenkins/casc
fi

echo "Executing the pipeline"
echo "${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}/bin/jenkinsfile-runner "$1" -w ${JENKINS_ROOT}/jenkins.war -p ${JENKINS_ROOT}/plugins -f $2"
${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}/bin/jenkinsfile-runner "$1" -w ${JENKINS_ROOT}/jenkins.war -p ${JENKINS_ROOT}/plugins -f $2