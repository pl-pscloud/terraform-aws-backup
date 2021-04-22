output "pscloud_backup_vault" {
  value = module.backup-vault-default.pscloud_backup_vault.name
}

output "pscloud_backup_cross_region_vault" {
  value = module.backup-vault-cross-region.pscloud_backup_vault.name 
}