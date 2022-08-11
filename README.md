# jenkins-action-poc
This is the POC of Jenkinsfile Runner Action for GitHub Actions in GSoC 2022.

## Table of Content
- [jenkins-action-poc](#jenkins-action-poc)
  - [Table of Content](#table-of-content)
  - [Introduction](#introduction)
  - [Pre-requisites](#pre-requisites)
  - [Inputs](#inputs)
    - [Container Actions Inputs](#container-actions-inputs)
      - [Shared Inputs of jfr-container-action and jfr-static-image-action](#shared-inputs-of-jfr-container-action-and-jfr-static-image-action)
      - [jfr-container-action Unique Inputs](#jfr-container-action-unique-inputs)
      - [jfr-static-image-action Unique Inputs](#jfr-static-image-action-unique-inputs)
    - [Runtime Actions Inputs](#runtime-actions-inputs)
      - [jenkins-setup](#jenkins-setup)
      - [jenkins-plugin-installation-action](#jenkins-plugin-installation-action)
      - [jenkinsfile-runner-action](#jenkinsfile-runner-action)
  - [How you can access these actions in your project?](#how-you-can-access-these-actions-in-your-project)
  - [Actions Comparisons](#actions-comparisons)
  - [Step by step usage](#step-by-step-usage)
    - [Container actions usage](#container-actions-usage)
    - [Runtime actions usage](#runtime-actions-usage)
  - [Example workflows](#example-workflows)
    - [Container job action](#container-job-action)
    - [Docker container action](#docker-container-action)
    - [Runtime action](#runtime-action)
  - [Advanced usage](#advanced-usage)
    - [Cache new installed plugins](#cache-new-installed-plugins)
    - [Pipeline log uploading service](#pipeline-log-uploading-service)
    - [Use your own base image as runtime](#use-your-own-base-image-as-runtime)
    - [Configure your instance by Groovy hook scripts](#configure-your-instance-by-groovy-hook-scripts)
  - [A small demo about how to use these actions](#a-small-demo-about-how-to-use-these-actions)

## Introduction
Jenkinsfile Runner Action for GitHub Actions aims at providing one-time runtime context for Jenkins pipeline. The users are able to run the pipeline in GitHub Actions by only providing the Jenkinsfile and the definition of GitHub workflow. This project is powered by [jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner) mainly. The plugin downloading step is powered by [plugin-installation-manager-tool](https://github.com/jenkinsci/plugin-installation-manager-tool).

You can configure the pipeline environment by using other GitHub Actions or providing JCasC Yaml file powered by [configuration-as-code-plugin](https://www.jenkins.io/projects/jcasc/).

## Pre-requisites
The users need to create the workflow definition under the `.github/workflows` directory. Refer to the [example workflows](#example-workflows) for more details about these actions.

## Inputs
### Container Actions Inputs
#### Shared Inputs of jfr-container-action and jfr-static-image-action
These inputs are provided by our container actions.
| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `command` | String | run | The command to run the [jenkinsfile-runner](https://github.com/jenkinsci/jenkinsfile-runner). The supported commands are `run` and `lint`. |
| `jenkinsfile` | String | Jenkinsfile | The relative path to Jenkinsfile. You can check [the official manual about Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/syntax/). |
| `pluginstxt` | String | plugins.txt | The relative path to plugins list file. You can check [the valid plugin input format](https://github.com/jenkinsci/plugin-installation-manager-tool#plugin-input-format). You can also refer to the [plugins.txt](plugins.txt) in this repository. |
| `jcasc` | String | N/A | The relative path to Jenkins Configuration as Code YAML file. You can refer to the [demos](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos) provided by `configuration-as-code-plugin` and learn how to configure the Jenkins instance without using UI page. |
| `initHook` | String | N/A | The relative path to the [Groovy init hook directory](https://www.jenkins.io/doc/book/managing/groovy-hook-scripts/). |
#### jfr-container-action Unique Inputs
| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `isPluginCacheHit` | boolean | false | You can choose whether or not to cache new installed plugins outside. If users want to use `actions/cache` in the workflow, they can give the cache hit status as input in `isPluginCacheHit`. |
#### jfr-static-image-action Unique Inputs
| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `baseImage` | String | N/A | You can choose your base runtime here. By default, it will pull the Jenkinsfile-runner jdk11 prebuilt container as runtime. |
### Runtime Actions Inputs
#### jenkins-setup
| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `jenkins-version` | String | 2.346.1 | The version of jenkins core to download. If you change the default value of `jenkins-core-url`, this option will be invalid. |
| `jenkins-root` | String | `./jenkins` | The root directory of jenkins binaries storage. |
| `jenkins-pm-version` | String | 2.5.0 | The version of plugin installation manager to use. If you change the default value of `jenkins-pm-url`, this option will be invalid. |
| `jfr-version` | String | 1.0-beta-30 | The version of Jenkinsfile-runner to use. If you change the default value of `jenkins-jfr-url`, this option will be invalid. |
| `jenkins-pm-url` | String | [plugin-installation-manager-tool GitHub release](https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.5.0/jenkins-plugin-manager-2.5.0.jar) | The download url of plugin installation manager. |
| `jenkins-core-url` | String | [Jenkins update center](https://updates.jenkins.io/download/war/2.346.1/jenkins.war) | The download url of Jenkins war package. |
| `jenkins-jfr-url` | String | [Jenkinsfile-runner GitHub release](https://github.com/jenkinsci/jenkinsfile-runner/releases/download/1.0-beta-30/jenkinsfile-runner-1.0-beta-30.zip) | The download url of Jenkinsfile-runner. |
#### jenkins-plugin-installation-action
| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `pluginstxt` | String | plugins.txt | The relative path to plugins list file. |
#### jenkinsfile-runner-action
| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `command` | String | run | The command to run the jenkinsfile-runner. The supported commands are `run` and `lint`. |
| `jenkinsfile` | String | Jenkinsfile | The relative path to Jenkinsfile. |
| `jcasc` | String | N/A | The relative path to Jenkins Configuration as Code YAML file. |
| `initHook` | String | N/A | The relative path to the Groovy init hook directory. |

## How you can access these actions in your project?
Reference these actions in your workflow definition.
1. Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
2. Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
3. Cr1t-GYM/jenkins-action-poc/jenkins-setup@master
4. Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
5. Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master

## Actions Comparisons
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

## Step by step usage
### Container actions usage
1. Prepare a Jenkinsfile in your repository. You can check [the basic syntax of Jenkins pipeline definition](https://www.jenkins.io/doc/book/pipeline/syntax/).
2. Prepare a workflow definition under the `.github/workflows` directory. You can check [the official manual](https://docs.github.com/en/actions) for more details.
3. In your GitHub Action workflow definition, you need to follow these steps when calling other actions in sequence:
   1. Use a ubuntu runner for the job.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest   
   ```
   2. If you use jfr-container-action, you need to declare using the `ghcr.io/jenkinsci/jenkinsfile-runner:master` or any image extended it. If you use jfr-static-image-action, you can skip this step.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        container:
          image: ghcr.io/jenkinsci/jenkinsfile-runner:master             
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
### Runtime actions usage
1. Prepare a Jenkinsfile in your repository.
2. Prepare a workflow definition under the `.github/workflows` directory.
3. In your GitHub Action workflow definition, you need to follow these steps when calling other actions in sequence:
   1. Use the runners you prefer. You can choose Linux, macOS or Windows.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest   
   ```   
   2. Call the `actions/checkout@v2` to pull your codes into the runner.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2           
   ```      
   3. Set up the Jenkins environment by using `Cr1t-GYM/jenkins-action-poc/jenkins-setup@master`.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - uese: Cr1t-GYM/jenkins-action-poc/jenkins-setup@master           
   ```    
   4. Install extra plugins by using `Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master`. This step is optional.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - uese: Cr1t-GYM/jenkins-action-poc/jenkins-setup@master
          - uses: Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
            with:
              pluginstxt: jenkins-setup/plugins.txt                     
   ```   
   5. Run the Jenkins pipeline by using `Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master`.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - uese: Cr1t-GYM/jenkins-action-poc/jenkins-setup@master
          - uses: Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
            with:
              pluginstxt: jenkins-setup/plugins.txt
          - uses: Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
            with:
              command: run
              jenkinsfile: Jenkinsfile
              jcasc: jcasc.yml                                   
   ```    

## Example workflows
There are three common cases about how to play with these actions. Although the user interfaces are similar to each other, there are still some subtle differences. The runtime actions are deprecated now. The users can use the [jfr-container-action](#container-job-action) and [jfr-static-image-action](#docker-container-action).
### Container job action
This case is realized by jfr-container-action. If the job uses this action, it will run the Jenkins pipeline and other GitHub Actions in the prebuilt container provided by [ghcr.io/jenkinsci/jenkinsfile-runner:master](https://github.com/jenkinsci/jenkinsfile-runner/pkgs/container/jenkinsfile-runner). The **extra prerequisite** of this action is that you need to declare the image usage of ghcr.io/jenkinsci/jenkinsfile-runner:master at the start of the job.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-container-pipeline:
    runs-on: ubuntu-latest
    name: jenkins-prebuilt-container-test
    container:
      # prerequisite
      image: ghcr.io/jenkinsci/jenkinsfile-runner:master
    steps:
      - uses: actions/checkout@v2
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
Some users might want to configure the container environment. The recommendation is that you should extend the [ghcr.io/jenkinsci/jenkinsfile-runner:master](https://github.com/jenkinsci/jenkinsfile-runner/pkgs/container/jenkinsfile-runner) vanilla image and then you need to build and push it to your own registry. Finally, you can replace the vanilla image with your own custimized image. The invocation of jfr-container-action can be done in a similar way.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-container-pipeline:
    runs-on: ubuntu-latest
    name: jenkins-prebuilt-container-test
    container:
      # prerequisite: extendance of ghcr.io/jenkinsci/jenkinsfile-runner:master
      image: path/to/your_own_image
    steps:
      - uses: actions/checkout@v2
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
### Runtime action
This case is realized by the combination of jenkins-setup, jenkins-plugin-installation-action and jenkinsfile-runner-action. It will download all the dependencies and run the pipeline at the host machine directly. Its advantage is that it can support Linux, macOS and Windows runners. Its main disadvantage is the possibility of suffering from a plugins.jenkins.io outage.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-runtime-pipeline:
    # Run all the actions in the on demand VM.
    needs: syntax-check
    strategy:
      matrix:
        os: [ubuntu-latest, macOS-latest, windows-latest]    
    runs-on: ${{ matrix.os }}
    name: jenkins-runtime-pipeline-test
    steps:
      - uses: actions/checkout@v2
      - name : Setup Jenkins
        uses: Cr1t-GYM/jenkins-action-poc/jenkins-setup
      - name: Jenkins plugins download
        id: jenkins_plugins_download
        uses: Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action
        with:
          pluginstxt: jenkins-setup/plugins.txt
      - name: Run Jenkins pipeline
        id: run_jenkins_pipeline
        uses: Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action
        with:
          command: run
          jenkinsfile: Jenkinsfile
          jcasc: jcasc.yml
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
### Use your own base image as runtime
This feature is only available in `jfr-static-image-action`. You can specify the base image in `baseImage`. For instance, if you want to use npm official image as the base runtime, you can specify 'node:18.3.0' as input and then you can use `npm` in your Jenkinsfile. An alternative way to implement is declaring in the JCasC.
```Yaml
      - name: Jenkins pipeline with the static image
        id: jenkins_pipeline_base_image
        uses:
          ./jfr-static-image-action
        env:
          JENKINS_AWS_KEY: 123456
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins_container.txt
          jcasc: jcasc.yml
          baseImage: 'node:18.3.0'  
```
### Configure your instance by Groovy hook scripts
This feature is available in `jenkinsfile-runner-action`, `jfr-container-action` and `jfr-static-image-action`. Sometimes JCasC cannot provide adequate configutation settings and you might find that setting up a Groovy hook scripts is useful in that case. Your groovy scripts will be executed right after Jenkins and before your actual pipeline start up. These scripts allows full access to all of the classes in the Jenkins core and installed plugins. The following example is based on `jfr-container-action` but it works in the same way as the other actions. Please note that you will need to provide a directory which contains your groovy scripts not as a single file.
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
          initHook: test.groovy 
```

## A small demo about how to use these actions
The [Demo project](https://github.com/Cr1t-GYM/JekinsTest) can teach you how to build a SpringBoot project with these actions.