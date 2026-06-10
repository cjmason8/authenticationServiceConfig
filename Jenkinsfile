#!/usr/bin/groovy

def project = "authService"
def version = -1
def imageName = "auth-service"

node {
    stage('Checkout') {
        // Clean up old files but preserve .env file
        sh '''
            # Remove all files except .env
            find . -mindepth 1 -maxdepth 1 ! -name '.env' -exec rm -rf {} +
        '''
        
        sh 'git clone git@github.com:cjmason8/authenticationServiceConfig.git tmp_config'
        sh 'mv tmp_config/* tmp_config/.git* . 2>/dev/null || true'
        sh 'rm -rf tmp_config'
        
        sh 'git clone git@github.com:cjmason8/authService.git'
    }

    stage('Update Version') {
        sh './updateVersion.sh'

        version = readFile('VERSION').trim()
    }

    stage('Build') {
        sh "./build.sh $imageName $version"
    }

    stage('Tag and Push') {
        sh "./tagAndPush.sh $imageName $version"
    }

    stage('Deploy Prod') {
        withCredentials([usernamePassword(credentialsId: 'Rancher', passwordVariable: 'SECRETKEY', usernameVariable: 'ACCESSKEY')]) {
            sh './deploy.sh $ACCESSKEY $SECRETKEY http://161.97.133.187:8080/v2-beta/projects/1a5 prd'
        }
    }
}