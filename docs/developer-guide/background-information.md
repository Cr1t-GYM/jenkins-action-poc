---
layout: default
title: Background information
parent: Developer Guide
nav_order: 1
---

# Background information
Jenkinsfile Runner Action for GitHub Actions provides the customized containerized environment and useful GitHub Actions for users to run the Jenkins pipeline inside GitHub Actions. 

In more detail, if using these actions, any GitHub project which has a Jenkinsfile can execute its workflow in the GitHub Actions runner. It aims at applying Jenkins in the GitHub Actions in a Function-as-a-Service context. This feature is based on the Jenkinsfile Runner, which is a command line tool for the Jenkins pipeline execution engine. The user can define the Jenkins pipeline environment by choosing different base images and configuring the Jenkins Configuration-as-Code plugin.

Now we have 5 different actions. The jenkins-setup and jenkins-plugin-installation-action are only used to set up the jenkins environment, while jenkinsfile-runner-action, jfr-container-action and jfr-static-image-action can run the pipeline. The jenkins-setup, jenkins-plugin-installation-action and jenkinsfile-runner-action work as a whole to start the pipeline in the host machine directly. On the other hand, jfr-container-action and jfr-static-image-action run the pipeline in the customized container.
