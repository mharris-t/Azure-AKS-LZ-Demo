data "azurerm_key_vault" "keyvault" {
  name                = "lz-keyvault"
  resource_group_name = "gov-keyvault"
}

data "azurerm_key_vault_secret" "aks_ssh" {
  name         = "ssh-key-linux"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "aks_admin_username" {
  name         = "cluster_admin_username"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}