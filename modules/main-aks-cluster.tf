resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.aks_rg.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.cluster_name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

  default_node_pool {
    name                 = "${var.cluster_name}-nodepool"
    vm_size              = var.vm_size
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = var.availability_zones
    enable_auto_scaling  = var.enable_auto_scaling
    max_count            = var.nodepool_max_count
    min_count            = var.nodepool_min_count
    os_disk_size_gb      = var.nodepool_disk_size
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id       = azurerm_subnet.aks-default.id 
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "${var.cluster_name}"
      "nodepools"        = "linux"
      "app"              = "system-apps" 
    } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "${var.cluster_name}"
      "nodepools"        = "linux"
   } 
  }

# Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

# Add On Profiles
  addon_profile {
    azure_policy {enabled =  true}
    oms_agent {
      enabled =  true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }

# RBAC and Azure AD Integration Block
  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      admin_group_object_ids = [azuread_group.aks_administrators.id]
    }
  }

# Windows Profile
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }

# Linux Profile
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

# Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }

  tags = {
    Environment = "${var.cluster_name}"
  }
}