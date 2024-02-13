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

