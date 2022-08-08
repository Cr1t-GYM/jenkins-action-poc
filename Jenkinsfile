pipeline {
    agent any
    stages {
        stage('hello') {
            steps {
                sh 'echo Hello Jenkins!'
            }
        }
        stage('test runner env') {
            when {
                environment name: 'GITHUB_ACTION', value: 'jenkins_pipeline_base_image'
            }
            steps {
                sh 'echo mock aws access key is $JENKINS_AWS_KEY'
            }
        }
        stage('test casc env') {
            steps {
                echo "JCasC env.hello: ${env.hello}"
            }
        }
    }
}
