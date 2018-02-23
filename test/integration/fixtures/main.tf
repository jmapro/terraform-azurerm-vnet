module "network" {
  source              = "../../../"
  resource_group_name = "${random_id.rg_name.hex}"
  location            = "eastus"
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  route_tables_ids    = ["azurerm_route_table.rt-subnet1.id", "azurerm_route_table.rt-subnet2.id", "azurerm_route_table.rt-subnet3.id"]
  nsg_ids = {
    subnet1 = "${azurerm_network_security_group.nsg1.id}"
  }

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}

resource "random_id" "rg_name" {
  byte_length = 8
}

//Create a resource group and nsg to use for testing nsg association.
resource "azurerm_resource_group" "myapp2" {
  name     = "${random_id.rg_name.hex}"
  location = "eastus"
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg1"
  resource_group_name = "${azurerm_resource_group.myapp2.name}"
  location            = "${azurerm_resource_group.myapp2.location}"
}

  resource "azurerm_route_table" "rt-subnet1" {
  depends_on          = ["module.vnet"]
  name                = "rt-subnet1"
  location            = "westus"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_route" "subnet1_default_gw" {
  name                = "subnet1_default_gw"
  resource_group_name = "${var.resource_group_name}"
  route_table_name    = "${azurerm_route_table.rt-subnet1.name}"
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.1.254"
}

resource "azurerm_route_table" "rt-subnet2" {
  depends_on          = ["module.vnet"]
  name                = "rt-subnet2"
  location            = "westus"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_route" "subnet2_default_gw" {
  name                = "subnet2_default_gw"
  resource_group_name = "${var.resource_group_name}"
  route_table_name    = "${azurerm_route_table.rt-subnet2.name}"
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.2.254"
}

resource "azurerm_route_table" "rt-subnet3" {
  depends_on          = ["module.vnet"]
  name                = "rt-subnet3"
  location            = "westus"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_route" "subnet3_default_gw" {
  name                = "subnet3_default_gw"
  resource_group_name = "${var.resource_group_name}"
  route_table_name    = "${azurerm_route_table.rt-subnet3.name}"
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.2.254"
}
