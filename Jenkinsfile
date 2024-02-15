pipeline {
    agent any
    
    environment {
        SUBSCRIPTION_ID = credentials('lil-sp-subscription-id')
        TENANT_ID       = credentials('lil-sp-tenant-id')
        CLIENT_ID       = credentials('lil-sp-client-id')
        CLIENT_SECRET   = credentials('lil-sp-client-secret-id')
        RESOURCE_GROUP_NAME = 'tfstaterg'
        STORAGE_ACCOUNT_NAME = 'lilibackendsa'
        CONTAINER_NAME = 'tfstatect'
        AZURE_CREDENTIALS_ID = 'your-azure-service-principal-credentials-id'
    }
    
    stages {
        stage('Azure Login') {
            steps {
                // Use withCredentials to securely retrieve Azure service principal credentials
                withCredentials([azureServicePrincipal(credentialsId: 'lili-acr-credentials-id', tenantIdVariable: 'ARM_TENANT_ID', clientIdVariable: 'ARM_CLIENT_ID', clientSecretVariable: 'ARM_CLIENT_SECRET')]) {
                    script {
                        // Set environment variables for Terraform using retrieved credentials
                        withEnv(["TF_VAR_subscription_id=${SUBSCRIPTION_ID}",
                                 "TF_VAR_tenant_id=${TENANT_ID}",
                                 "TF_VAR_client_id=${CLIENT_ID}",
                                 "TF_VAR_client_secret=${CLIENT_SECRET}"]) {
                            
                        }
                    }
                }
            }
        }
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
