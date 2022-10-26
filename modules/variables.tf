#! Azure Location
variable "location" {
  type = string
  description = "Azure Region"
  default = "West Europe"
}

#! Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "Resource Group Name"
  default = "dev"
}

variable "cluster_name" {
  type = string
  description = "Cluster Name"
  default = "aks"
}

variable "availability_zones" {
  type = list
  description = "Azure Availability Zones"
  default = [1]
}

variable "enable_auto_scaling" {
  type = bool
  description = "Azure Availability Zones"
  default = true
}

variable "admin_username" {
  type = string
  description = "Azure AKS Admin Username"
  default = "admin"
}

variable "vnet_adress_space" {
  type = string
  description = "VNET Address Space for K8s Cluster"
  default = "10.0.0.0/8"
}

variable "k8s_subnet" {
  type = string
  description = "Subnet Address Space for K8s Cluster"
  default = "10.0.10.0/16"
}

variable "nodepool_min_count" {
  type = number
  description = "Min count for node pool"
  default = 1
}

variable "nodepool_max_count" {
  type = number
  description = "Max count for node pool"
  default = 2
}

variable "nodepool_disk_size" {
  type = number
  description = "Disk size for node pool"
  default = 30
}
variable "vm_size" {
  type = string
  description = "VM Size"
  default = "Standard_DS2_v2"
}

variable "ssh_public_key" {
  default = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
  description = "SSH Public Key for Linux k8s Worker nodes"  
}