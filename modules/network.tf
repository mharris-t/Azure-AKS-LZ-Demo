# Create Virtual Network
resource "azurerm_virtual_network" "k8s_vnet" {
  name                = "${var.cluster_name}-network"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  address_space       = ["${var.vnet_address_space}"]
}

# Create a Subnet for AKS
resource "azurerm_subnet" "k8s_subnet" {
  name                 = "${var.cluster_name}-subnet"
  virtual_network_name = azurerm_virtual_network.k8s_vnet.name
  resource_group_name  = azurerm_resource_group.aks_rg.name
  address_prefixes     = ["${var.k8s_subnet}"]
}