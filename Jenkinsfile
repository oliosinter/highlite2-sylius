node {
    checkout scm

    try {
        stage ('Build release images') {
            sh 'make ci-release-build'

        stage ('Tag and publish release images') {
            sh "make ci-release-tag latest \$(git rev-parse --short HEAD) \$(git tag --points-at HEAD)"
            withEnv(["DOCKER_USER=${DOCKER_USER}", "DOCKER_PASSWORD=${DOCKER_PASSWORD}"]) {
                sh "make ci-release-login"
            }
            sh 'make ci-release-publish'
        }
    }
    finally {
        stage ('Clean up') {
            sh 'make ci-release-clean'
            sh 'make ci-release-logout'
        }
    }
}