---
layout: default
title: Advanced usage
parent: User Guide
nav_order: 6
---

# Advanced usage
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}
## Cache new installed plugins
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
## Pipeline log uploading service
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
## Use your own base image as runtime
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