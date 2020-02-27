/*

Server 2016 Domain Controller
Server 2016 Member Server (File server too)
VMSS Web server set with a Load Balancer
Ubuntu 18.04 LTS Web Server
Insecure Web App
Azure SQL database
Azure Key Vault
Azure storage account for images or something
AKS Cluster with pet store app running

*/




#############################################################################
# PROVIDERS
#############################################################################

provider "azurerm" {
  version = "~> 1.0"
}

#############################################################################
# RESOURCES
#############################################################################

resource "random_integer" "prefix_num" {
  min = 10000
  max = 99999
}

module "vnet_main" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = "${terraform.workspace}-net"
  location            = var.location
  vnet_name           = "${terraform.workspace}-net"
  address_space       = var.vnet_cidr_range
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  nsg_ids             = {}

  tags = {
    environment = terraform.workspace

  }
}

# Create 2 Server 2016 servers

  module "windowsservers" {
    source                        = "Azure/compute/azurerm"
    resource_group_name           = "${terraform.workspace}-winvms"
    location                      = var.location
    vm_hostname                   = "winvm"
    admin_password                = "MoYsH@JT7qeB6maA"
    public_ip_dns                 = ["winvm${random_integer.prefix_num.result}1", "winvm${random_integer.prefix_num.result}2"]
    nb_public_ip                  = "2"
    remote_port                   = "3389"
    nb_instances                  = "2"
    vm_os_publisher               = "MicrosoftWindowsServer"
    vm_os_offer                   = "WindowsServer"
    vm_os_sku                     = "2016-Datacenter"
    vm_size                       = "Standard_DS2_V3"
    is_windows_image              = "true"
    vnet_subnet_id                = "${module.vnet_main.vnet_subnets[1]}"
    enable_accelerated_networking = "true"
  }

  

# Create a VMSS running a basic web site

# Create a load balancer for the VMSS exposing port 80

# Create an Ubuntu 18.04 server

# Create an App Service Web App with an insecure application

# Create an Azure SQL server and database

# Create an Azure Key Vault

# Create an Azure storage account

# Create an AKS cluster