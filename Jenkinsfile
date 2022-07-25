pipeline {
    agent any
    stages {
        stage('hello') {
            steps {
                sh 'echo Hello Jenkins!'
                sh 'echo $GITHUB_ACTION'
            }
        }
        stage('test casc env') {
            steps {
                echo "JCasC env.hello: ${env.hello}"
            }
        }
    }
}