---
layout: default
title: Inputs
parent: User Guide
nav_order: 2
---

# Inputs
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}
## Container Actions Inputs
### Shared Inputs of jfr-container-action and jfr-static-image-action
These inputs are provided by our container actions.

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `command` | String | run | The command to run the [jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner). The supported commands are `run` and `lint`. |
| `jenkinsfile` | String | Jenkinsfile | The relative path to Jenkinsfile. You can check [the official manual about Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/syntax/). |
| `pluginstxt` | String | plugins.txt | The relative path to plugins list file. You can check [the valid plugin input format](https://github.com/jenkinsci/plugin-installation-manager-tool#plugin-input-format). You can also refer to the [plugins.txt](plugins.txt) in this repository. |
| `jcasc` | String | N/A | The relative path to Jenkins Configuration as Code YAML file. You can refer to the [demos](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos) provided by `configuration-as-code-plugin` and learn how to configure the Jenkins instance without using UI page. |

### jfr-container-action Unique Inputs

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `isPluginCacheHit` | boolean | false | You can choose whether or not to cache new installed plugins outside. If users want to use `actions/cache` in the workflow, they can give the cache hit status as input in `isPluginCacheHit`. |

### jfr-static-image-action Unique Inputs

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `baseImage` | String | N/A | You can choose your base runtime here. By default, it will pull the Jenkinsfile-runner jdk11 prebuilt container as runtime. |

## Runtime Actions Inputs
### jenkins-setup

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `jenkins-version` | String | 2.346.1 | The version of jenkins core to download. If you change the default value of `jenkins-core-url`, this option will be invalid. |
| `jenkins-root` | String | `./jenkins` | The root directory of jenkins binaries storage. |
| `jenkins-pm-version` | String | 2.5.0 | The version of plugin installation manager to use. If you change the default value of `jenkins-pm-url`, this option will be invalid. |
| `jfr-version` | String | 1.0-beta-30 | The version of Jenkinsfile-runner to use. If you change the default value of `jenkins-jfr-url`, this option will be invalid. |
| `jenkins-pm-url` | String | [plugin-installation-manager-tool GitHub release](https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.5.0/jenkins-plugin-manager-2.5.0.jar) | The download url of plugin installation manager. |
| `jenkins-core-url` | String | [Jenkins update center](https://updates.jenkins.io/download/war/2.346.1/jenkins.war) | The download url of Jenkins war package. |
| `jenkins-jfr-url` | String | [Jenkinsfile-runner GitHub release](https://github.com/jenkinsci/jenkinsfile-runner/releases/download/1.0-beta-30/jenkinsfile-runner-1.0-beta-30.zip) | The download url of Jenkinsfile-runner. |

### jenkins-plugin-installation-action

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `pluginstxt` | String | plugins.txt | The relative path to plugins list file. |

### jenkinsfile-runner-action

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `command` | String | run | The command to run the jenkinsfile-runner. The supported commands are `run` and `lint`. |
| `jenkinsfile` | String | Jenkinsfile | The relative path to Jenkinsfile. |
| `jcasc` | String | N/A | The relative path to Jenkins Configuration as Code YAML file. |
