#!/usr/bin/env bash
set -euo pipefail

echo "JENKINS_ROOT=$JENKINS_ROOT" >> "$GITHUB_ENV"
# If you change the default value of JENKINS_PM_URL, JENKINS_PM_VERSION will be invalid.
if [[ "$JENKINS_PM_URL" =~ ^https://github.com/jenkinsci/plugin-installation-manager-tool.* ]]
then
    JENKINS_PM_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/"${JENKINS_PM_VERSION}"/jenkins-plugin-manager-"${JENKINS_PM_VERSION}".jar
fi
# If you change the default value of JENKINS_CORE_URL, JENKINS_VERSION will be invalid.
if [[ "$JENKINS_CORE_URL" =~ ^https://updates.jenkins.io/download/war.* ]]
then
    JENKINS_CORE_URL=https://updates.jenkins.io/download/war/"${JENKINS_VERSION}"/jenkins.war
fi
# If you change the default value of JENKINS_JFR_URL, JFR_VERSION will be invalid.
if [[ "$JENKINS_JFR_URL" =~ ^https://github.com/jenkinsci/jenkinsfile-runner.* ]]
then
    JENKINS_JFR_URL=https://github.com/jenkinsci/jenkinsfile-runner/releases/download/"${JFR_VERSION}"/jenkinsfile-runner-"${JFR_VERSION}".zip
fi

# download Jenkins core
mkdir -p "${JENKINS_ROOT}"
echo "Downloading Jenkins $JENKINS_VERSION core..."
curl --silent --location "${JENKINS_CORE_URL}" --output "${JENKINS_ROOT}"/jenkins.war
# download Jenkinsfile-runner
echo "Downloading Jenkinsfile runner..."
curl --silent --location "${JENKINS_JFR_URL}" --output "${JENKINS_ROOT}"/jenkinsfile-runner-"${JFR_VERSION}".zip
unzip -q "${JENKINS_ROOT}"/jenkinsfile-runner-"${JFR_VERSION}".zip -d "${JENKINS_ROOT}"/jenkinsfile-runner
chmod +x "${JENKINS_ROOT}"/jenkinsfile-runner/bin/jenkinsfile-runner
mkdir -p "${GITHUB_WORKSPACE}/jenkins/casc"
unzip -q "${JENKINS_ROOT}"/jenkins.war -d "${JENKINS_ROOT}"/jenkins
mkdir -p "${JENKINS_ROOT}"/jenkins/WEB-INF/groovy.init.d
cp "${GITHUB_ACTION_PATH}/init.groovy" "${JENKINS_ROOT}"/jenkins/WEB-INF/groovy.init.d/
# download plugin manager
echo "Downloading Jenkins plugin manager..."
curl --silent --location "$JENKINS_PM_URL" --output "${JENKINS_ROOT}"/jenkins-plugin-manager.jar
echo "Downloading latest minimum required plugins for pipeline..."
java -jar "${JENKINS_ROOT}"/jenkins-plugin-manager.jar --war "${JENKINS_ROOT}"/jenkins.war --plugin-file "${GITHUB_ACTION_PATH}/plugins.txt" --plugin-download-directory="${JENKINS_ROOT}"/plugins

echo "Jenkins environment has been set up..."
