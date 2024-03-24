# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
  #type = set(string)
  #default = ["dev", "stg"]
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "rg"
}
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "East US"
}

# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "cos-vnet01"
}

# 2. Application Name
variable "Application_name" {
  description = "Application Name"
  type = string
  default = "infra"
  #type = set(string)
  #default = ["essence", "Infoware"]
}

# Define SKU for each VM
variable "VM_sku" {
  description = "Specify SKU per VM"
  type        = map
  default     = {
    "HTR1500" = "Standard_DS1_v2"
    "HTR1900" = "Standard_DS2_v2"
  }
}

variable "inbound_rules" {
  type    = list(map(any))
  default = [
    {
      name     = "WebServer"
      priority = 100
      port     = 80
    },
    {
      name     = "RDP"
      priority = 110
      port     = 3389
    },
    {
      name     = "SSH"
      priority = 120
      port     = 22
    },
    # Add more rules as needed
  ]
}





# Define the data disks you want to create
variable "data_disks" {
  type = map(object({
    name                 = string
    disk_size_gb         = number
    create_option        = string
    caching              = string
    lun                  = number
    storage_account_type = string
  }))
  default = {
    "HTR1500" = {
      name                 = "data_disk_1"
      disk_size_gb         = 5
      create_option        = "Empty"
      caching              = "None"
      lun                  = 1
      storage_account_type = "Standard_LRS"
    },
    "HTR1900" = {
      name                 = "data_disk_3"
      disk_size_gb         = 10
      create_option        = "Empty"
      caching              = "WriteOnly"
      lun                  = 1
      storage_account_type = "Standard_LRS"
    }
  }
}

# Common tags
variable "common_tags" {
  description = "Common tags for Azure resources"
  type        = map
  default = {
    environment = "staging"
    department  = "IT"
    Owner      = "Hriyen"
    Cos_Managed = "yes"
  }
}
