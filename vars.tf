variable "pscloud_env" {}
variable "pscloud_company" {}

variable "pscloud_kms_key_arn" {}
variable "pscloud_purpose" {}

variable "pscloud_schedule" {}
variable "pscloud_start_window" {}
variable "pscloud_completion_window" {}
variable "pscloud_recovery_point_tags" {}

variable "pscloud_cold_storage_after" { default = null}
variable "pscloud_delete_after" { default = null}

variable "pscloud_backup_resources" {}