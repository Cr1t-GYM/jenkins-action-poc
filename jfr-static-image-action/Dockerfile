FROM ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master

COPY entrypoint.sh /entrypoint.sh
RUN cd /app/jenkins && jar -cvf jenkins.war *

ENTRYPOINT ["/entrypoint.sh"]