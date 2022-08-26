resource "random_pet" "random" {
  length = 1
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic-${random_pet.random.id}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${var.prefix}-ipconfiguration-${random_pet.random.id}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.vm_name}-${random_pet.random.id}"
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = var.vm_size
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd1234!"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = var.disk_size_gb
  }
}