# Create a resource group
resource "azurerm_resource_group" "arg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "liliacr"                             #your acr name
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Output Registry Name
output "registry_name" {
  value = azurerm_container_registry.acr.name
}

# Output Login Server
output "login_server" {
  value = azurerm_container_registry.acr.login_server
}

# Output Username
output "username" {
  value = azurerm_container_registry.acr.admin_username
}

# After ACR is created, you will get admin password from access keys in your repository, then it will be use in jenkins credentials.


# Create AKS Cluster and Grant ACR Pull acess
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "lili_cluster"                  #your AKS name
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  dns_prefix          = "liliaks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Add authentication command for AKS
resource "null_resource" "authenticate_aks" {
  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials --resource-group ${azurerm_resource_group.arg.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing
    EOT

    interpreter = ["bash", "-c"]
  }
}

# Create acr pull access for AKS Cluster
resource "azurerm_role_assignment" "arm_role" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "null_resource" "create_storage" {
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash

      RESOURCE_GROUP_NAME=tfstate
      STORAGE_ACCOUNT_NAME=tfstate${random_id.random.hex}
      CONTAINER_NAME=tfstate

      # Create resource group
      az group create --name $RESOURCE_GROUP_NAME --location westeurope

      # Create storage account
      az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

      # Create blob container
      az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
    EOT
  }
}
