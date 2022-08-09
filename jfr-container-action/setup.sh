#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 && $# -ge 4 ]]
then
    echo "Invalid parameters."
    exit 1
fi

if [[ $# -ge 3 && $3 != "" ]]
then
    echo "Set up JCasC."
    cp "$3" "${CASC_JENKINS_CONFIG}"
fi

if [[ $# == 4 && $4 != "" ]]
then
    for f1 in $4
    do
        for f2 in /app/jenkins/WEB-INF/groovy.init.d/*
        do
            f1=$(basename "$f1")
            f2=$(basename "$f2")
            if [ $f1 == $f2 ]
            then
                echo "There is a name conflict between $f1 and $f2. You need to rename $f1 to other name."
                exit 1
            fi
        done
    done
    cp "$4"/* /app/jenkins/WEB-INF/groovy.init.d
fi

echo "Running Jenkins pipeline."
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2" --runHome /jenkinsHome --withInitHooks /app/jenkins/WEB-INF/groovy.init.d
echo "The pipeline log is available at /jenkinsHome/jobs/job/builds"
