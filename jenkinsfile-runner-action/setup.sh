#!/usr/bin/env bash
set -e

JENKINS_ROOT=./jenkins
JFR_VERSION=1.0-beta-30

if [ $# == 3 ]
then
    cp ${GITHUB_WORKSPACE}/$3 ${GITHUB_WORKSPACE}/jenkins/casc
fi

echo "Executing the pipeline"
echo "${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}/bin/jenkinsfile-runner "$1" -w ${JENKINS_ROOT}/jenkins -p ${JENKINS_ROOT}/plugins -f $2"
${JENKINS_ROOT}/jenkinsfile-runner-${JFR_VERSION}/bin/jenkinsfile-runner "$1" -w ${JENKINS_ROOT}/jenkins -p ${JENKINS_ROOT}/plugins -f $2