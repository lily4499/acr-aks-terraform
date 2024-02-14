# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
}
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id       = "689aee19-d95c-4dfb-9b53-7a103ded4190"
  tenant_id             = "98932122-35ff-47e5-a539-0942b55eb83c"
  client_id             = "ae3623f2-05e8-4b53-ba3c-1e4e98a5433a"
  client_secret         = "mpY8Q~22DXTl~XF1Q6lC_QeF33PshfljmXGrlayZ"
}
