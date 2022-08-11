#!/usr/bin/env bash
set -euo pipefail

echo "Download plugins."
java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$3" --plugin-download-directory=/usr/share/jenkins/ref/plugins

if [[ $# -ge 4 && $4 != "" ]]
then
    echo "Set up JCasC."
    cp "$4" "${CASC_JENKINS_CONFIG}"
fi

if [[ $# == 5 && $5 != "" ]]
then
    for f1 in $5
    do
        for f2 in /app/jenkins/WEB-INF/groovy.init.d/*
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
    cp "$5"/* /app/jenkins/WEB-INF/groovy.init.d
fi

echo "Running Jenkins pipeline."
mkdir -p jenkinsHome
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$2" --runHome jenkinsHome --withInitHooks /app/jenkins/WEB-INF/groovy.init.d
echo "The pipeline log is available at jenkinsHome/jobs/job/builds"
