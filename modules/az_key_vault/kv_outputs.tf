
output "final_win-vm_pswd" {
  value     = azurerm_key_vault_secret.win-vm-pswd.value
  sensitive = true
}

output "key-vault-uri" {
  description = "Key Vault URI"
  value       = data.azurerm_key_vault.azkv-name.vault_uri
}