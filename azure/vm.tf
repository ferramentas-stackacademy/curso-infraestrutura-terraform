resource "azurerm_virtual_network" "terraform-course" {
  name                = "terraform-course-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform-course.location
  resource_group_name = azurerm_resource_group.terraform-course.name
}

resource "azurerm_subnet" "terraform-course" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.terraform-course.name
  virtual_network_name = azurerm_virtual_network.terraform-course.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_resource_group" "terraform-course" {
  name     = "terraform-course-resources"
  location = "West Europe"
}

resource "azurerm_network_security_group" "terraform-course" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.terraform-course.location
  resource_group_name = azurerm_resource_group.terraform-course.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}


resource "azurerm_public_ip" "terraform-course" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.terraform-course.name
  location            = azurerm_resource_group.terraform-course.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}


resource "azurerm_network_interface" "terraform-course" {
  name                = "terraform-course-nic"
  location            = azurerm_resource_group.terraform-course.location
  resource_group_name = azurerm_resource_group.terraform-course.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform-course.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.terraform-course.id
  network_security_group_id = azurerm_network_security_group.terraform-course.id
}

resource "azurerm_linux_virtual_machine" "terraform-course" {
  name                = "terraform-course-machine"
  resource_group_name = azurerm_resource_group.terraform-course.name
  location            = azurerm_resource_group.terraform-course.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  disable_password_authentication = false
  admin_password = "Stack2022!"
  
  network_interface_ids = [
    azurerm_network_interface.terraform-course.id,
  ]


#   admin_ssh_key {
#     username   = "adminuser"
#     #public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}