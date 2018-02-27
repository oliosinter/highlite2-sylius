node {
    checkout scm

    try {
        stage ('Build') {
            sh 'make ci-release-build'
        }

       stage ('Deploy') {
            sh 'make ci-prod-run'
        }
    }
    finally {
        stage ('Clean') {
            sh 'make ci-release-clean'
        }
    }
}