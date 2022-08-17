---
layout: default
title: Actions Comparisons
parent: User Guide
nav_order: 3
---

# Actions Comparisons
We only compare `jfr-container-action`, `jfr-static-image-action` and `jenkinsfile-runner-action` here. `jenkins-setup` and `jenkins-plugin-installation-action` are only used to set up the environment.

| Comparables | jfr-container-action | jfr-static-image-action | jenkinsfile-runner-action |
| ----------- | ----------- | ----------- | ----------- |
| Do they run in the Jenkins container or run in the host machine? | It runs in the Jenkins container | It runs in the Jenkins container | It runs in the host machine directly |
| When will the Jenkins container start in users workflow? | It will start before all the actions start | It will start when jfr-static-image-action starts | N/A |
| When will the Jenkins container end in users workflow? | It will end after all the actions end | It will end immediately after jfr-static-image-action ends | N/A |
| Can it be used with other GitHub actions? | Yes | No, except `actions/checkout` to set up workspace | Yes |
| Prerequisites | Needs to refer `ghcr.io/jenkinsci/jenkinsfile-runner:master` or its extended images | No | Needs to set up the environment by `jenkins-setup`. If you want to download extra plugins, you need to run `jenkins-plugin-installation-action` |
| Do they support installing new plugins? | Yes | Yes | New plugins needs to be installed by `jenkins-plugin-installation-action` |
| Do they support using configuraion-as-code-plugin? | Yes | Yes | Yes |
| Valid Environment Variables in the action | No Constraints | Must be started with JENKINS_ | No Constraints |
| What kind of runners do it support? | Linux | Linux | Linux, macOS, Windows |