#!/usr/bin/env bash
set -e

JENKINS_VERSION=2.346.1
JENKINS_PM_VERSION=2.5.0
JENKINS_PM_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_PM_VERSION}/jenkins-plugin-manager-${JENKINS_PM_VERSION}.jar
JENKINS_CORE_URL=http://updates.jenkins.io/download/war/${JENKINS_VERSION}/jenkins.war
JFR_VERSION=1.0-beta-30
JENKINS_JFR_URL=https://github.com/jenkinsci/jenkinsfile-runner/releases/download/${JFR_VERSION}/jenkinsfile-runner-${JFR_VERSION}.zip

# download Jenkins core
mkdir -p /app
echo "Downloading Jenkins core"
curl -L ${JENKINS_CORE_URL} -o /app/jenkins.war
unzip /app/jenkins.war -d /app/jenkins

echo "Downloading Jenkinsfile-runner"
curl -L ${JENKINS_JFR_URL} -o /app/jenkinsfile-runner-${JFR_VERSION}.zip
unzip -q /app/jenkinsfile-runner-${JFR_VERSION}.zip -d /app
rm /app/jenkinsfile-runner-${JFR_VERSION}.zip
chmod +x /app/bin/jenkinsfile-runner

# download plugin manager
echo "Downloading plugin manager"
wget $JENKINS_PM_URL -O /app/bin/jenkins-plugin-manager.jar

# download plugins
echo "Downloading minimum required plugins..."
mkdir -p /usr/share/jenkins/ref/plugins
java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins.war --plugin-file "$1" --plugin-download-directory=/usr/share/jenkins/ref/plugins

echo "Jenkins plugins has been set up"