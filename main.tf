resource "aws_backup_vault" "pscloud-backup-vault" {

  name        = "${var.pscloud_company}_backup_vault_${var.pscloud_env}"
  
  kms_key_arn = var.pscloud_kms_key_arn

  tags = {
    Name = "${var.pscloud_company}_backup_vault_${var.pscloud_env}"
    Purpose = "backup_vault_for_${var.pscloud_purpose}"
  }
}

resource "aws_backup_plan" "pscloud-backup-plan" {

  name  = "${var.pscloud_company}_backup_plan_${var.pscloud_env}"

  rule {
    rule_name           = "${var.pscloud_company}_backup_rule_${var.pscloud_env}"
    target_vault_name   = aws_backup_vault.pscloud-backup-vault.name
    schedule            = var.pscloud_schedule
    start_window        = var.pscloud_start_window
    completion_window   = var.pscloud_completion_window
    recovery_point_tags = var.pscloud_recovery_point_tags

    dynamic "lifecycle" {
      for_each = var.pscloud_cold_storage_after != null || var.pscloud_delete_after != null ? ["true"] : []
      content {
        cold_storage_after = var.pscloud_cold_storage_after
        delete_after       = var.pscloud_delete_after
      }
    }
  }
}

resource "aws_backup_selection" "pscloud-backup-selection" {

  name         = "${var.pscloud_company}_backup_selection_${var.pscloud_env}"

  iam_role_arn = aws_iam_role.pscloud-iam-role.arn
  plan_id      = aws_backup_plan.pscloud-backup-plan.id
  resources    = var.pscloud_backup_resources
}