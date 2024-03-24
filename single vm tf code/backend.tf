# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
  backend "azurerm" {
    resource_group_name = "app-grp"
    storage_account_name = "narstorageacc01"
    container_name = "data-container"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
