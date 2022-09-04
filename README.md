# jfr-setup-action

This is a brief introduction of `jfr-setup-action`.
It can help users install all necessary dependencies to run the Jenkins pipeline in the GitHub Actions Runner host machine.
If you want to learn more about the usage of this action,
you can check the [central documentation page](https://jenkinsci.github.io/jfr-action-doc).

## Inputs

| Name | Type | Default Value | Description |
| ----------- | ----------- | ----------- | ----------- |
| `jenkins-version` | String | 2.346.1 | The version of jenkins core to download. If you change the default value of `jenkins-core-url`, this option will be invalid. |
| `jenkins-root` | String | `./jenkins` | The root directory of jenkins binaries storage. |
| `jenkins-pm-version` | String | 2.5.0 | The version of plugin installation manager to use. If you change the default value of `jenkins-pm-url`, this option will be invalid. |
| `jfr-version` | String | 1.0-beta-30 | The version of Jenkinsfile-runner to use. If you change the default value of `jenkins-jfr-url`, this option will be invalid. |
| `jenkins-pm-url` | String | [plugin-installation-manager-tool GitHub release](https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.5.0/jenkins-plugin-manager-2.5.0.jar) | The download url of plugin installation manager. |
| `jenkins-core-url` | String | [Jenkins update center](https://updates.jenkins.io/download/war/2.346.1/jenkins.war) | The download url of Jenkins war package. |
| `jenkins-jfr-url` | String | [Jenkinsfile-runner GitHub release](https://github.com/jenkinsci/jenkinsfile-runner/releases/download/1.0-beta-30/jenkinsfile-runner-1.0-beta-30.zip) | The download url of Jenkinsfile-runner. |

## Example

Please note this action doesn't run the Jenkins pipeline.
You need to use `jfr-runtime-action` instead.
You can call this action by using `jenkinsci/jfr-setup-action@master`.

```yaml
name: CI
on: [push]
jobs:
  jfr-runtime-action-pipeline:
    strategy:
      matrix:
        os: [ ubuntu-latest, macOS-latest, windows-latest ]
    runs-on: ${{matrix.os}}
    name: jfr-runtime-action-pipeline
    steps:
      - uses: actions/checkout@v2
      - name : Setup Jenkins
        uses:
          jenkinsci/jfr-runtime-action@master
      - name: Jenkins plugins download
        uses:
          jenkinsci/jfr-plugin-installation-action@master
        with:
          pluginstxt: plugins.txt
      - name: Run Jenkins pipeline
        uses:
          jenkinsci/jfr-runtime-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
```
