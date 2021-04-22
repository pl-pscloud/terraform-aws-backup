resource "aws_backup_vault" "pscloud-backup-vault" {
  name        = "${var.pscloud_company}_backup_vault_${var.pscloud_purpose}_${var.pscloud_env}"

  kms_key_arn = var.pscloud_kms_key_arn

  tags = {
    Name      = "${var.pscloud_company}_backup_vault_${var.pscloud_purpose}_${var.pscloud_env}"
    Purpose   = "backup_vault_for_${var.pscloud_purpose}"
  }
}