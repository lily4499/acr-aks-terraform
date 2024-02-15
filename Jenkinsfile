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
                    // Get connection string for the storage account if it exists
                    def connectionString = sh(script: "az storage account show-connection-string --name ${STORAGE_ACCOUNT_NAME} --query connectionString -o tsv", returnStdout: true, returnStatus: true).trim()

                    // Check if the storage account exists
                    if (connectionString) {
                        // If the storage account exists, use the obtained connection string
                        // Set the connection string as an environment variable
                        env.STORAGE_CONNECTION_STRING = connectionString
                    } else {
                        // If the storage account does not exist, set STORAGE_CONNECTION_STRING to an empty string
                        env.STORAGE_CONNECTION_STRING = ''
                    }
                }
            }
        }
        
        stage('Install Resource Backend for Azure') {
            steps {
                script {
                    // Create resource group
                    sh "az group create --name ${RESOURCE_GROUP_NAME} --location eastus"
                    
                    // Create storage account only if the connection string is not already available
                    if (!env.STORAGE_CONNECTION_STRING) {
                        // Create storage account
                        sh "az storage account create --resource-group ${RESOURCE_GROUP_NAME} --name ${STORAGE_ACCOUNT_NAME} --sku Standard_LRS --encryption-services blob"
                    }
                    
                    // Get the connection string again after creating the storage account
                    def connectionString = sh(script: "az storage account show-connection-string --name ${STORAGE_ACCOUNT_NAME} --query connectionString -o tsv", returnStdout: true).trim()
                    
                    // Set the connection string as an environment variable
                    env.STORAGE_CONNECTION_STRING = connectionString
                    
                    // Create blob container
                    sh "az storage container create --name ${CONTAINER_NAME} --connection-string ${env.STORAGE_CONNECTION_STRING}"
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
