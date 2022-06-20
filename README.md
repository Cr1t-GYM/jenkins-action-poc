# jenkins-action-poc
This is the POC of Jenkinsfile Runner Action for GitHub Actions in GSoC 2022.

## How you can access these actions in your project?
Reference these actions in your workflow definition.
1. Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
2. Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
3. Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
4. Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master

Example workflow definition.
```Yaml
name: Java CI
on: [push]
jobs:
  jenkins-runtime-pipeline:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Jenkins plugins download
        id: jenkins_plugins_download
        uses:
          Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
        with:
          pluginstxt: plugins_min.txt
      - name: Run Jenkins pipeline
        id: run_jenkins_pipeline
        uses:
          Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          jcasc: jcasc_runtime.yml
```

## A small demo about how to use these actions
[Demo project](https://github.com/Cr1t-GYM/JekinsTest)