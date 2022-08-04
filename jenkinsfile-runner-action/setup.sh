#!/usr/bin/env bash
set -euo pipefail


if [ $# == 3 ]
then
    cp "$3" "${GITHUB_WORKSPACE}/jenkins/casc"
fi

echo "Executing the pipeline..."
mkdir jenkinsHome
${JENKINS_ROOT}/jenkinsfile-runner/bin/jenkinsfile-runner "$1" -w ${JENKINS_ROOT}/jenkins -p ${JENKINS_ROOT}/plugins -f "$2" --runHome jenkinsHome --withInitHooks ${JENKINS_ROOT}/jenkins/WEB-INF/groovy.init.d
echo "The pipeline log is available at jenkinsHome/jobs/job/builds"
