# jenkins-action-poc
This is the POC of Jenkinsfile Runner Action for GitHub Actions in GSoC 2022.

## Table of Content
- [jenkins-action-poc](#jenkins-action-poc)
  - [Table of Content](#table-of-content)
  - [Introduction](#introduction)
  - [Pre-requisites](#pre-requisites)
  - [Inputs](#inputs)
    - [Shared Inputs](#shared-inputs)
    - [jfr-static-image-action Unique Inputs](#jfr-static-image-action-unique-inputs)
  - [How you can access these actions in your project?](#how-you-can-access-these-actions-in-your-project)
  - [Actions Comparisons](#actions-comparisons)
  - [Step by step usage](#step-by-step-usage)
  - [Example workflows](#example-workflows)
    - [Container job action](#container-job-action)
    - [Docker container action](#docker-container-action)
    - [Runtime action (Deprecated)](#runtime-action-deprecated)
  - [Advanced usage](#advanced-usage)
    - [Cache new installed plugins](#cache-new-installed-plugins)
    - [Pipeline log uploading service](#pipeline-log-uploading-service)
  - [A small demo about how to use these actions](#a-small-demo-about-how-to-use-these-actions)

## Introduction
Jenkinsfile Runner Action for GitHub Actions aims at providing one-time runtime context for Jenkins pipeline. The users are able to run the pipeline in GitHub Actions by only providing the Jenkinsfile and the definition of GitHub workflow. This project is powered by [jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner) mainly. The plugin downloading step is powered by [plugin-installation-manager-tool](https://github.com/jenkinsci/plugin-installation-manager-tool).

You can configure the pipeline environment by using other GitHub Actions or providing JCasC Yaml file powered by [configuration-as-code-plugin](https://www.jenkins.io/projects/jcasc/).

## Pre-requisites
The users need to create the workflow definition under the `.github/workflows` directory. Refer to the [example workflows](#example-workflows) for more details about these actions.

## Inputs
### Shared Inputs
These inputs are provided by all of our actions.
* `command` - The command to run the [jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner). The supported commands are `run`, `lint`, `cli`, `generate-completion`, `version` and `help`. The default command is run.
* `jenkinsfile` - The relative path to Jenkinsfile. The default file name is Jenkinsfile. You can check [the official manual about Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/syntax/).
* `pluginstxt` - The relative path to plugins list file. The default file name is plugins.txt. You can check [the valid plugin input format](https://github.com/jenkinsci/plugin-installation-manager-tool#plugin-input-format). You can also refer to the [plugins.txt](plugins.txt) in this repository.
* `jcasc` - The relative path to Jenkins Configuration as Code YAML file. You can refer to the [demos](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos) provided by `configuration-as-code-plugin` and learn how to configure the Jenkins instance without using UI page.
### jfr-static-image-action Unique Inputs
* `isPluginCacheHit` - You can choose whether or not to cache new installed plugins outside. If users want to use `actions/cache` in the workflow, they can give the cache hit status as input in `isPluginCacheHit`. Default input is false.

## How you can access these actions in your project?
Reference these actions in your workflow definition.
1. Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
2. Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
3. Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
4. Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master

## Actions Comparisons
We only compare `jfr-container-action` and `jfr-static-image-action` here because the others are deprecated.

| Comparables | jfr-container-action | jfr-static-image-action |
| ----------- | ----------- | ----------- |
| Do they run in the Jenkins container or run in the host machine? | It runs in the Jenkins container | It runs in the Jenkins container |
| When will the Jenkins container start in users workflow? | It will start before all the actions start | It will start when jfr-static-image-action starts |
| When will the Jenkins container end in users workflow? | It will end after all the actions end | It will end immediately after jfr-static-image-action ends |
| Can it be used with other GitHub actions? | Yes | No, except `actions/checkout` to set up workspace |
| Prerequisites | Needs to refer `ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master` or its extended images | No |
| Do they support installing new plugins? | Yes | Yes |
| Do they support using configuraion-as-code-plugin? | Yes | Yes |

## Step by step usage
1. Prepare a Jenkinsfile in your repository. You can check [the basic syntax of Jenkins pipeline definition](https://www.jenkins.io/doc/book/pipeline/syntax/).
2. Prepare a workflow definition under the `.github/workflows` directory. You can check [the official manual](https://docs.github.com/en/actions) for more details.
3. In your GitHub Action workflow definition, you need to follow these steps when calling other actions in sequence:
   1. Use a ubuntu runner for the job.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest   
   ```
   2. If you use jfr-container-action, you need to declare using the `ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master` or any image extended it. If you use jfr-static-image-action, you can skip this step.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        container:
          image: ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master             
   ```   
   3. Call the `actions/checkout@v2` to pull your codes into the runner. "Call" means `uses` in the workflow definition specifically. You can check [the details about "uses" keyword](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsuses).
   ```Yaml
   - uses: actions/checkout@v2
   ```
   4. Call the Jenkinsfile-runner actions.
      1. If you use jfr-container-action, you need to call `Cr1t-GYM/jenkins-action-poc/jfr-container-action@master` and give necessary inputs.
      ```Yaml
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml      
      ```
      2.  If you use jfr-static-image-action, you need to call `Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master` and give necessary inputs. See the [examples](#example-workflows) for these two actions.
      ```Yaml
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml      
      ```

## Example workflows
There are three common cases about how to play with these actions. Although the user interfaces are similar to each other, there are still some subtle differences. The runtime actions are deprecated now. The users can use the [jfr-container-action](#container-job-action) and [jfr-static-image-action](#docker-container-action).
### Container job action
This case is realized by jfr-container-action. If the job uses this action, it will run the Jenkins pipeline and other GitHub Actions in the prebuilt container provided by [ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master](https://github.com/Cr1t-GYM/Jenkinsfile-runner-image-release-test/pkgs/container/jenkinsfile-runner-image-release-test). The **extra prerequisite** of this action is that you need to declare the image usage of ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master at the start of the job.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-container-pipeline:
    runs-on: ubuntu-latest
    name: jenkins-prebuilt-container-test
    container:
      # prerequisite
      image: ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master
    steps:
      - uses: actions/checkout@v2
      - name: Set up Maven
        uses: stCarolas/setup-maven@v4.3
        with:
          maven-version: 3.6.3
      # jfr-container-action
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
```
Some users might want to configure the container environment. The recommendation is that you can extend the [ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master](https://github.com/Cr1t-GYM/Jenkinsfile-runner-image-release-test/pkgs/container/jenkinsfile-runner-image-release-test) vanilla image and then you need to build and push it to your own registry. Finnaly, you can replace the vanilla image with your own custimized image. The invocation of jfr-container-action is the same in this way.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-container-pipeline:
    runs-on: ubuntu-latest
    name: jenkins-prebuilt-container-test
    container:
      # prerequisite: extendance of ghcr.io/cr1t-gym/jenkinsfile-runner-image-release-test:master
      image: path/to/your_own_image
    steps:
      - uses: actions/checkout@v2
      - name: Set up Maven
        uses: stCarolas/setup-maven@v4.3
        with:
          maven-version: 3.6.3
      # jfr-container-action
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
```
### Docker container action
This case is realized by jfr-static-image-action. This action has its own working environment. It won't have extra environment relationship with the on demand VM outside unless the user mounts other directories to the container (For example, checkout action if exists). After the docker action ends, this container will be deleted. The users may check the introduction of [Docker container action](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action#introduction) before using this action.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-static-image-pipeline:
    runs-on: ubuntu-latest
    name: jenkins-static-image-pipeline-test
    steps:
      - uses: actions/checkout@v2
      # jfr-static-image-action
      - name: Jenkins pipeline with the static image
        id: jenkins_pipeline_image
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
```
### Runtime action (Deprecated)
This case is realized by the combination of jenkins-plugin-installation-action and jenkinsfile-runner-action. It will download all the dependencies and run the pipeline at the runtime. Its main disadvantage is the possibility of suffering from a plugins.jenkins.io outage.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-runtime-pipeline:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      # jenkins-plugin-installation-action
      - name: Jenkins plugins download
        id: jenkins_plugins_download
        uses:
          Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
        with:
          pluginstxt: plugins_min.txt
      # jenkinsfile-runner-action
      - name: Run Jenkins pipeline
        id: run_jenkins_pipeline
        uses:
          Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          jcasc: jcasc_runtime.yml
```

## Advanced usage
### Cache new installed plugins
This feature is only available in `jfr-container-action`. By default, the plugins specified by `plugins.txt` will be downloaded from the Internet everytime you run the workflow. In order to accelarate the workflow, you can use `actions/cache` outside and give its cache hit status as input in `isPluginCacheHit`. There are three important details here.

1. The `path` input in `actions/cache` must be `/jenkins_new_plugins`.
2. If you want to use `plugins.txt` as `key` for cache, you need to keep the `key` input in `actions/cache` consistent with `pluginstxt` input in `jfr-container-action`.
3. You need to pass cache hit status by `isPluginCacheHit`. For example, ff the step id of your `actions/cache` step is `cache-jenkins-plugins`, the input of `isPluginCacheHit` should be `${{steps.cache-jenkins-plugins.outputs.cache-hit}}`.
```Yaml
      # Cache new plugins in /jenkins_new_plugins by hash(plugins.txt)
      - uses: actions/cache@v3
        id: cache-jenkins-plugins
        name: Cache Jenkins plugins
        with:
          path: /jenkins_new_plugins
          key: ${{ runner.os }}-plugins-${{ hashFiles('plugins.txt') }}      
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
          isPluginCacheHit: ${{steps.cache-jenkins-plugins.outputs.cache-hit}}
``` 
### Pipeline log uploading service
This feature is available for `jfr-container-action` and `jfr-static-image-action`. After you run the Jenkins pipeline, the pipeline log will be available in `/jenkinsHome/jobs/job/builds` for `jfr-container-action` and `jenkinsHome/jobs/job/builds` for `jfr-static-image-action`. Therefore, you are able to upload the log to the GitHub Action page by using `actions/upload-artifact`.

Log uploading example for `jfr-container-action`.
```Yaml
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins_container.txt
          jcasc: jcasc.yml
          isPluginCacheHit: ${{steps.cache-jenkins-plugins.outputs.cache-hit}}
      # Upload pipeline log in /jenkinsHome/jobs/job/builds
      - name: Upload pipeline Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: jenkins-container-pipeline-log
          path: /jenkinsHome/jobs/job/builds
```
Log uploading example for `jfr-static-image-action`.
```Yaml
      - name: Jenkins pipeline with the static image
        id: jenkins_pipeline_image
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins_container.txt
          jcasc: jcasc.yml
      # Upload pipeline log in jenkinsHome/jobs/job/builds      
      - name: Upload pipeline Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: jenkins-static-image-pipeline-log
          path: jenkinsHome/jobs/job/builds
```

## A small demo about how to use these actions
The [Demo project](https://github.com/Cr1t-GYM/JekinsTest) can teach you how to build a SpringBoot project with these actions.