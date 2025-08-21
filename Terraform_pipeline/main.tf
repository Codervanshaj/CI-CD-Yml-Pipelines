resource "azurerm_resource_group" "rg" {
  name     = "myrg-test-001"
  location = var.location
}

module "winVM" {
  source = "./modules"
  rg_name = azurerm_resource_group.rg.name
  location = var.location
  disk_type = var.managed_disk_type
  password = var.admin_password


}
