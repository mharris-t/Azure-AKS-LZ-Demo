# Azure Location
variable "location" {
  type = string
  description = "Azure Region"
  default = "West Europe"
}

# Azure Resource Group Name
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

# Azure AKS Environment Name
variable "environment" {
  type = string  
  description = "This variable defines the Environment"  
  default = "dev"
}

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
  description = "SSH Public Key for Linux k8s Worker nodes"  
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type = string
  default = "aksuser"
  description = "Admin username for k8s Worker nodes"  
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type = string
  default = "P@ssw0rd1234"
  description = "This variable defines the Windows admin password k8s Worker nodes"  
}