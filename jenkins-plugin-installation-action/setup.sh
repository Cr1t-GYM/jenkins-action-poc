#!/usr/bin/env bash
set -euo pipefail

PLUGIN_LIST=plugins.txt

if [ $# == 1 ]
then
    PLUGIN_LIST="$1"
fi

if [ ! -f "$PLUGIN_LIST" ]
then
    echo "$PLUGIN_LIST doesn't exist."
    exit 1
fi

java -jar "${JENKINS_ROOT}/jenkins-plugin-manager.jar" --war "${JENKINS_ROOT}/jenkins.war" --plugin-file "${PLUGIN_LIST}" --plugin-download-directory="${JENKINS_ROOT}/plugins"
echo "Jenkins plugins has been set up."
