#! Creates resource group and AKS Cluster within the resource group. 

resource "azurerm_resource_group" "aks_rg" {
  name     = "${var.resource_group_name}-rg"
  location = var.location
}

data "azurerm_kubernetes_service_versions" "current" {
  location        = azurerm_resource_group.aks_rg.location
  include_preview = false
}

#! Deploys latest version of K8s cluster.
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                   = "${var.cluster_name}-cluster"
  location               = azurerm_resource_group.aks_rg.location
  resource_group_name    = azurerm_resource_group.aks_rg.name
  dns_prefix             = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version     = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group    = "${azurerm_resource_group.aks_rg.name}-nrg"

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

#! Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    azure_policy {enabled =  true}
    oms_agent {
      enabled =  true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }

  tags = {
    Environment = "${var.cluster_name}"
  }
}

#! Required versions.
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}