data "aws_iam_policy_document" "assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pscloud-iam-role" {

  name               = "${var.pscloud_company}_backup_selection_iam_role_for_${var.pscloud_purpose}_${var.pscloud_env}"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)

  tags = {
    Name = "${var.pscloud_company}_backup_selection_iam_role_for_${var.pscloud_purpose}_${var.pscloud_env}"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.pscloud-iam-role.name
}
