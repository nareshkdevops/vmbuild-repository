
resource "azurerm_managed_disk" "data_disks" {
  for_each = var.data_disks

  name                 = each.value.name
  location             = azurerm_resource_group.HriyenRG.location
  resource_group_name  = azurerm_resource_group.HriyenRG.name
  #location            = data.azurerm_resource_group.existing_rg.location
  #resource_group_name = data.azurerm_resource_group.existing_rg.name
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  storage_account_type = each.value.storage_account_type

  tags = {
    environment = "Stg"
    Owner   = "Hriyen"
  }
}

# Attach the data disks to the Windows Server VM

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  for_each = var.data_disks
  managed_disk_id    = azurerm_managed_disk.data_disks[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.VMs_01[each.key].id
  lun                = 1
  caching            = "ReadOnly"
}



# Create Boot Diagnostic Storage Account
resource "azurerm_storage_account" "storage" {
  name = "narstorageaccboot0"
  #location            = data.azurerm_resource_group.existing_rg.location
  #resource_group_name = data.azurerm_resource_group.existing_rg.name
   resource_group_name  = azurerm_resource_group.HriyenRG.name
   location          = azurerm_resource_group.HriyenRG.location
   account_kind             = "StorageV2"
   account_tier             = "Standard"
   account_replication_type = "LRS"
   tags = {
    Owner = "Hriyen"
   }
}
# Create log Analytics Workspace
resource "azurerm_log_analytics_workspace" "Workspace-01" {
    name = "${var.Application_name}-${var.environment}-workspace01"
    resource_group_name = azurerm_resource_group.HriyenRG.name
    location = azurerm_resource_group.HriyenRG.location
    allow_resource_only_permissions = "true"
    internet_ingestion_enabled = "true"
    internet_query_enabled = "true"
    sku = "PerGB2018"
    retention_in_days = "30"
}

resource "azurerm_virtual_machine_extension" "windows_log_analytics_extension" {
  for_each = var.VM_sku

  virtual_machine_id     = azurerm_windows_virtual_machine.VMs_01[each.key].id
  name                   = "LogAnalytics"
  publisher              = "Microsoft.EnterpriseCloud.Monitoring"
  type                   = "MicrosoftMonitoringAgent"
  type_handler_version   = "1.0"
  auto_upgrade_minor_version = true  # Add this line

  protected_settings = <<PROTECTED_SETTINGS
  {
    "workspaceKey": "${azurerm_log_analytics_workspace.Workspace-01.primary_shared_key}"
  }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
  {
    "workspaceId": "${azurerm_log_analytics_workspace.Workspace-01.workspace_id}"
  }
  SETTINGS

  tags = {
    environment = var.environment
    application = var.Application_name
    sku         = each.value
  }
}
