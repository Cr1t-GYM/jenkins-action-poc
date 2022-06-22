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
                echo "JCasC env.hello: ${env.hello}"
            }
        }
        stage('write plain log text') {
            steps {
                script {
                    def log = currentBuild.rawBuild
                    def baos = new ByteArrayOutputStream()
                    log.getLogText().writeLogTo(0, baos)
                    println(baos.toString())
                }
            }
        }
    }
}