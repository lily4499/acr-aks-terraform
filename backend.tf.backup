terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate"  # Specify the Azure resource group for backend storage
    storage_account_name  = "lilibackend"  # Specify the name of the Azure Storage Account
    container_name        = "tfstate"               # Specify the container within the Storage Account
    key                   = "terraform.tfstate"      # Specify the filename for the Terraform state file
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
  }
}
