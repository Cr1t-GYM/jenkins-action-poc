---
layout: default
title: User Guide
nav_order: 3
permalink: /user-guide
has_children: true
---

# User guide
Jenkinsfile Runner Action for GitHub Actions aims at providing one-time runtime context for Jenkins pipeline. The users are able to run the pipeline in GitHub Actions by only providing the Jenkinsfile and the definition of GitHub workflow. This project is powered by [jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner) mainly. The plugin downloading step is powered by [plugin-installation-manager-tool](https://github.com/jenkinsci/plugin-installation-manager-tool).

You can configure the pipeline environment by using other GitHub Actions or providing JCasC Yaml file powered by [configuration-as-code-plugin](https://www.jenkins.io/projects/jcasc/).

## How you can access these actions in your project?
Reference these actions in your workflow definition.
1. Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
2. Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
3. Cr1t-GYM/jenkins-action-poc/jenkins-setup@master
4. Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
5. Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master
