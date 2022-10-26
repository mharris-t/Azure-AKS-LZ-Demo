module "aks_env" {
    source              = "../modules/"
    for_each            = local.cluster_env
    location            = "West Europe"
    resource_group_name = "${each.key}"
    cluster_name        = "${each.key}"
    availability_zones  = each.value.availability_zones
    enable_auto_scaling = each.value.enable_auto_scaling
    vnet_adress_space   = each.value.vnet_adress_space
    k8s_subnet          = each.value.k8s_subnet
    nodepool_min_count  = each.value.nodepool_min_count
    nodepool_max_count  = each.value.nodepool_max_count
    nodepool_disk_size  = each.value.nodepool_disk_size
    vm_size             = each.value.vm_size
    ssh_public_key      = each.value.ssh_public_key
    admin_username      = each.value.admin_username
}

locals {
    cluster_env = {
        dev = {
            availability_zones  = [1]
            enable_auto_scaling = false
            vnet_adress_space   = "10.0.0.0/8"
            k8s_subnet          = "10.1.0.0/16"
            nodepool_min_count  = 1
            nodepool_max_count  = 1
            nodepool_disk_size  = 10
            vm_size             = "Standard_DS1_v2"
            admin_username      = data.azurerm_key_vault_secret.aks_admin_username.value
            ssh_public_key      = data.azurerm_key_vault_secret.aks_ssh.value
        },
        test = {
            availability_zones  = [1]
            enable_auto_scaling = true
            vnet_adress_space   = "10.0.0.0/8"
            k8s_subnet          = "10.2.0.0/16"
            nodepool_min_count  = 1
            nodepool_max_count  = 2
            nodepool_disk_size  = 30
            vm_size             = "Standard_DS2_v2"
            admin_username      = data.azurerm_key_vault_secret.aks_admin_username.value
            ssh_public_key      = data.azurerm_key_vault_secret.aks_ssh.value
        }
        staging = {
            availability_zones  = [1,2,3]
            enable_auto_scaling = true
            vnet_adress_space   = "10.0.0.0/8"
            k8s_subnet          = "10.3.0.0/16"
            nodepool_min_count  = 1
            nodepool_max_count  = 4
            nodepool_disk_size  = 100
            vm_size             = "Standard_DS3_v2"
            admin_username      = data.azurerm_key_vault_secret.aks_admin_username.value
            ssh_public_key      = data.azurerm_key_vault_secret.aks_ssh.value
        }
    }
}

