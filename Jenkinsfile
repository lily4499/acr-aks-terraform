pipeline {
    agent any
    
    environment {
        RESOURCE_GROUP_NAME = 'tfstaterg'
        STORAGE_ACCOUNT_NAME = 'lilibackendsa'
        CONTAINER_NAME = 'tfstatect'
    }
    
    stages {
        stage('Get Connection String') {
            steps {
                script {
                    // Get connection string for the storage account
                    def connectionString = sh(script: "az storage account show-connection-string --name ${STORAGE_ACCOUNT_NAME} --query connectionString -o tsv", returnStdout: true).trim()
                    
                    // Set the connection string as an environment variable
                    env.STORAGE_CONNECTION_STRING = connectionString
                }
            }
        }
        
        stage('Create Blob Container') {
            steps {
                script {
                    // Create blob container
                    sh "az storage container create --name ${CONTAINER_NAME} --connection-string '${env.STORAGE_CONNECTION_STRING}'"
                }
            }
        }
        
        stage('Trigger Jenkins Job to Create ACR and AKS') {
            when {
                expression {
                    currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    // Trigger another Jenkins job to create ACR and AKS
                    build job: 'Create-ACR-and-AKS-Resource', wait: false
                }
            }
        }
    }
}

