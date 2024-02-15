pipeline {
    agent any
    
    environment {
        RESOURCE_GROUP_NAME = 'tfstaterg'
        STORAGE_ACCOUNT_NAME = 'lilibackendsa'
        CONTAINER_NAME = 'tfstatect'
    }
    
    stages {
        stage('Install Resource Backend for Azure') {
            steps {
                script {
                    // Create resource group
                    sh "az group create --name ${RESOURCE_GROUP_NAME} --location eastus"
                    
                    // Create storage account
                    sh "az storage account create --resource-group ${RESOURCE_GROUP_NAME} --name ${STORAGE_ACCOUNT_NAME} --sku Standard_LRS --encryption-services blob"
                    
                    // Create blob container
                    sh "az storage container create --name ${CONTAINER_NAME} --account-name ${STORAGE_ACCOUNT_NAME}"
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
