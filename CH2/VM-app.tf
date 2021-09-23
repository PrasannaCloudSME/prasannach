# Create Network Security Group and rule
resource "azurerm_network_security_group" "tfappnsg" {
  name                = "${var.prefix}-appnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"

 

  security_rule {
      name                       = "APPSSl"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
  }

  security_rule {
      name                       = "HTTP_VNET"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.0.1.0/24" // replace with ASG later
      destination_address_prefix = "*"
  }

  
}

# Create network interface
resource "azurerm_network_interface" "tfappnic" {
  count                     = "${var.appcount}"
  name                      = "${var.prefix}-appnic${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tfrg.name}"
  

  ip_configuration {
    name                          = "${var.prefix}-appnic-conf${count.index}"
    subnet_id                     = "${azurerm_subnet.tfappvnet.id}"
    #private_ip_address_allocation = "dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${format("10.0.2.%d", count.index + 4)}"
    
  }

  
}

resource "azurerm_availability_set" "tfappavset" {
  name                        = "${var.prefix}-appavset"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.tfrg.name}"
  managed                     = "true"
  platform_fault_domain_count = 2  

}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "tfappvm" {
  count                 = "${var.appcount}"
  name                  = "${var.prefix}appvm${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tfrg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfappnic.*.id[count.index]}"]
  availability_set_id   = "${azurerm_availability_set.tfappavset.id}"
  size               = "${var.vmsize}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
 

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  
}

