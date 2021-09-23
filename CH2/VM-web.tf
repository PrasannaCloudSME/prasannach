# Create Network Security Group and rule
resource "azurerm_network_security_group" "tfwebnsg" {
  name                = "${var.prefix}-webnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "webssl"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  
}

resource "azurerm_public_ip" "Webpublicip" {
    name                    = "${var.prefix}PublicIP"
    location                = var.location
    resource_group_name       = "${azurerm_resource_group.tfrg.name}"
    allocation_method       = "Dynamic"
    sku                     = "Basic"
}

# Create network interface
resource "azurerm_network_interface" "tfwebnic" {
  count                     = "${var.webcount}"
  name                      = "${var.prefix}-webnic${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tfrg.name}"
  

  ip_configuration {
    name                          = "${var.prefix}-webnic-config${count.index}"
    subnet_id                     = "${azurerm_subnet.tfwebvnet.id}"
    private_ip_address_allocation = "dynamic"
    #private_ip_address_allocation = "Static"
    
    private_ip_address            = "${format("10.0.1.%d", count.index + 4)}"
    
    
  
    
  }

  
}

resource "azurerm_availability_set" "tfwebavset" {
  name                        = "${var.prefix}-webavset"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.tfrg.name}"
  managed                     = "true"
  platform_fault_domain_count = 2 

  
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "tfwebvm" {
  count                 = "${var.webcount}"
  name                  = "${var.prefix}webvm${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tfrg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfwebnic.*.id[count.index]}"]
  size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.tfwebavset.id}"
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




