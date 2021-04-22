provider "aws" {
  profile    = var.awsprofile
  region     = var.pscloud_region
}

provider "aws" {
  alias      = "cr"

  profile    = var.awsprofile
  region     = var.pscloud_cross_region
}


module "backup-vault-default" {
  source  = "./backup-vault"

  pscloud_env           = var.pscloud_env
  pscloud_company       = var.pscloud_company
  pscloud_kms_key_arn   = var.pscloud_kms_key_arn
  pscloud_purpose       = var.pscloud_purpose

}

module "backup-vault-cross-region" {
  count   = var.pscloud_enabled_cross_region == true ? 1 : 0

  source  = "./backup-vault"

  providers = {
    aws = aws.cr
  }

  pscloud_env           = var.pscloud_env
  pscloud_company       = var.pscloud_company
  pscloud_kms_key_arn   = var.pscloud_kms_key_cross_region_arn
  pscloud_purpose       = "${var.pscloud_purpose}_cross_region"

}



resource "aws_backup_plan" "pscloud-backup-plan" {
  name  = "${var.pscloud_company}_backup_plan_${var.pscloud_purpose}_${var.pscloud_env}"

  rule {
    rule_name           = "${var.pscloud_company}_backup_rule_${var.pscloud_purpose}_${var.pscloud_env}"
    target_vault_name   = module.backup-vault-default.pscloud_backup_vault.name
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

    dynamic "copy_action" {
      for_each = var.pscloud_enabled_cross_region == true ? ["true"] : []
      content {
        dynamic "lifecycle" {
          for_each = var.pscloud_cold_storage_after != null || var.pscloud_delete_after != null ? ["true"] : []
          content {
            cold_storage_after = var.pscloud_cold_storage_after
            delete_after       = var.pscloud_delete_after
          }
        }
        destination_vault_arn = module.backup-vault-cross-region[0].pscloud_backup_vault.arn
      }
    }
  }
}

resource "aws_backup_selection" "pscloud-backup-selection" {
  name         = "${var.pscloud_company}_backup_selection_${var.pscloud_purpose}_${var.pscloud_env}"

  iam_role_arn = aws_iam_role.pscloud-iam-role.arn
  plan_id      = aws_backup_plan.pscloud-backup-plan.id
  resources    = var.pscloud_backup_resources
}