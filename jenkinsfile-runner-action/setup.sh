#!/usr/bin/env bash
set -euo pipefail


if [[ $# -ge 3 && $3 != "" ]]
then
    cp "$3" "${GITHUB_WORKSPACE}/jenkins/casc"
fi

if [[ $# == 4 && $4 != "" ]]
then
    for f1 in $4
    do
        for f2 in "${JENKINS_ROOT}"/jenkins/WEB-INF/groovy.init.d/*
        do
            f1=$(basename "$f1")
            f2=$(basename "$f2")
            if [ "$f1" == "$f2" ]
            then
                echo "There is a name conflict between $f1 and $f2. You need to rename $f1 to other name."
                exit 1
            fi
        done
    done
    cp "$4"/* "${JENKINS_ROOT}"/jenkins/WEB-INF/groovy.init.d
fi

echo "Executing the pipeline..."
mkdir jenkinsHome
"${JENKINS_ROOT}"/jenkinsfile-runner/bin/jenkinsfile-runner "$1" -w "${JENKINS_ROOT}"/jenkins -p "${JENKINS_ROOT}"/plugins -f "$2" --runHome jenkinsHome --withInitHooks "${JENKINS_ROOT}"/jenkins/WEB-INF/groovy.init.d
echo "The pipeline log is available at jenkinsHome/jobs/job/builds"
