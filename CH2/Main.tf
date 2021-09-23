
terraform {

  backend "azurerm" {

    resource_group_name = "prasademo-rg123"

    storage_account_name = "prasademosrtg12345"

    container_name = "prasannacontainer"

    key = "terraform.state"

    }

}


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.0.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
  features {
    
  }
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "tfrg" {
    name     = "${var.prefix}-rg"
    location = "${var.location}"


}

# Create virtual network
resource "azurerm_virtual_network" "tfvnet" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"

    
}



resource "azurerm_subnet" "tfwebvnet" {
  name                 = "web-subnet"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "tfappvnet" {
  name                 = "app-subnet"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  address_prefix       = "10.0.2.0/24"
 

}

resource "azurerm_storage_account" "Pstorage" {
  
  name                = "${var.PrasannaStorage}"
  location            = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  account_tier             = "Standard"
  account_replication_type = "GRS"


}
