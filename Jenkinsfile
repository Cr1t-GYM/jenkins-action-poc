pipeline {
    agent any
    stages {
        stage('hello') {
            steps {
                sh 'echo Hello Jenkins!'
            }
        }
        stage('test casc env') {
            steps {
                echo "JCasC env.PP: ${env.PP}"
            }
        }
    }
}