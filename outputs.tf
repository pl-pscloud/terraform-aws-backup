output "pscloud_backup_vault" {
  value = module.backup-vault-default.pscloud_backup_vault
}

output "pscloud_backup_cross_region_vault" {
  value = var.pscloud_enabled_cross_region == true ? module.backup-vault-cross-region[0].pscloud_backup_vault : null
}