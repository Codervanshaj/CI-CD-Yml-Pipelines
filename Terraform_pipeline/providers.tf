terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

  }
  backend "azurerm" {
    resource_group_name  = "myrg-test-001"
    storage_account_name  = "tfstatemyvanshstr"
    container_name       = "tfstatvanshcont"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

}


