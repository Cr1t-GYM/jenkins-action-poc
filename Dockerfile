FROM openjdk:11-jdk
USER root
ENV JDK_11 true

ENV JENKINS_UC https://updates.jenkins.io
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc
ADD setup.sh /setup.sh
ADD plugins.txt /plugins.txt

RUN mkdir -p /app /usr/share/jenkins/ref/plugins /usr/share/jenkins/ref/casc /app/bin \
    && echo "jenkins: {}" >/usr/share/jenkins/ref/casc/jenkins.yaml 

RUN /setup.sh /plugins.txt && rm -rf /setup.sh /plugins.txt
ENTRYPOINT ["/app/bin/jenkinsfile-runner"]