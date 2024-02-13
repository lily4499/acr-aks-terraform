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

# Output Password
output "password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

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


# Create acr pull access for AKS Cluster
resource "azurerm_role_assignment" "arm_role" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
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
