#!/usr/bin/groovy

def project = "authService"
def version = -1
def imageName = "auth-serive"

node {
    stage('Checkout') {
        def file = new File("checkout.sh")
        if (!file.exists()) {
            git(
                url: 'https://github.com/cjmason8/authServiceConfig.git',
                credentialsId: 'Github',
                branch: "master"
            )
            dir('authService') {
                git(
                    url: 'https://github.com/cjmason8/authService.git',
                    credentialsId: 'Github',
                    branch: "master"
                )    
            }
        }

        withCredentials([usernamePassword(credentialsId: 'Github', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            sh './checkout.sh $PASSWORD authService'
        }
    }

    stage('Update Version') {
        withCredentials([usernamePassword(credentialsId: 'Github', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            sh './updateVersion.sh $PASSWORD authService'
        }

        version = readFile('VERSION').trim()
    }

    stage('Build') {
        sh "./build.sh $imageName $version"
    }

    stage('Tag and Push') {
        sh "./tagAndPush.sh $imageName $version"
    }

    stage('Deploy') {
        withCredentials([usernamePassword(credentialsId: 'Rancher', passwordVariable: 'SECRETKEY', usernameVariable: 'ACCESSKEY')]) {
            sh './deploy.sh $ACCESSKEY $SECRETKEY'
        }
    }
}