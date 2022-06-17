FROM jenkins/jenkinsfile-runner

COPY entrypoint.sh /entrypoint.sh
RUN cd /app/jenkins && jar -cvf jenkins.war *

ENTRYPOINT ["/entrypoint.sh"]