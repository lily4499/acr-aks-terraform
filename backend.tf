terraform {
  backend "azurerm" {
    resource_group_name   = "lili-remote-backend-rg"  # Specify the Azure resource group for backend storage
    storage_account_name  = "lilibackendstorageacct"  # Specify the name of the Azure Storage Account
    container_name        = "lilitfstate"               # Specify the container within the Storage Account
    key                   = "liliterraform.tfstate"      # Specify the filename for the Terraform state file
  }
}
