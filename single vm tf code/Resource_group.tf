# Resource-1: Azure Resource Group1

resource "azurerm_resource_group" "HriyenRG" {
  name = "HT-dev-rg"
  location = "West US"
  tags = var.common_tags
}
