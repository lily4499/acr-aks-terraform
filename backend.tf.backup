terraform {
  backend "azurerm" {
    resource_group_name   = "lili-remote-backend-rg"  # Specify the Azure resource group for backend storage
    storage_account_name  = "lilibackendstorageacct"  # Specify the name of the Azure Storage Account
    container_name        = "lilitfstate"               # Specify the container within the Storage Account
    key                   = "liliterraform.tfstate"      # Specify the filename for the Terraform state file
    subscription_id       = "689aee19-d95c-4dfb-9b53-7a103ded4190"
    tenant_id             = "98932122-35ff-47e5-a539-0942b55eb83c"
    client_id             = "ae3623f2-05e8-4b53-ba3c-1e4e98a5433a"
    client_secret         = "mpY8Q~22DXTl~XF1Q6lC_QeF33PshfljmXGrlayZ"
  }
}
