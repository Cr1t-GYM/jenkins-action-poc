#!/usr/bin/env bash
set -e

JENKINS_ROOT=./jenkins

if [ $# == 3 ]
then
    cp $3 ${GITHUB_WORKSPACE}/jenkins/casc
fi

echo "Executing the pipeline..."
${JENKINS_ROOT}/jenkinsfile-runner/bin/jenkinsfile-runner "$1" -w ${JENKINS_ROOT}/jenkins -p ${JENKINS_ROOT}/plugins -f $2
