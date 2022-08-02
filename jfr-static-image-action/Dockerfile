FROM ghcr.io/jenkinsci/jenkinsfile-runner:master

COPY entrypoint.sh /entrypoint.sh
RUN cd /app/jenkins && jar -cvf jenkins.war * && mkdir /app/jenkins/WEB-INF/groovy.init.d
COPY init.groovy /app/jenkins/WEB-INF/groovy.init.d/init.groovy
ENTRYPOINT ["/entrypoint.sh"]
