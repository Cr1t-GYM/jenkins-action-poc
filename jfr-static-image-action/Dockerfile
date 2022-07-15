FROM ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master

COPY entrypoint.sh /entrypoint.sh
RUN cd /app/jenkins && jar -cvf jenkins.war * && mkdir /app/jenkins/WEB-INF/groovy.init.d
COPY init.groovy /app/jenkins/WEB-INF/groovy.init.d/init.groovy
ENTRYPOINT ["/entrypoint.sh"]