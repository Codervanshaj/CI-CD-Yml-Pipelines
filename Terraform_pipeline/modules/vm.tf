variable "location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "disk_type" {
  type = string
  
}

variable "password" {
  type = string
  sensitive = true
}




# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "DefaultSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "default-public-ip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku = "Standard"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "mynsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "VMnic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}



# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "VM-2"
  admin_username        = "azureuser"
  admin_password        = var.password
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_B2ms"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
}
