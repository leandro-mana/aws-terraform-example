###############################################
# AWS Secrets Manager Module                  #
# Creates a secret with fine-grained IAM      #
# policy to restrict access to the secret     #
###############################################
resource "aws_secretsmanager_secret" "secret" {
  name                    = var.secret_name
  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(var.secret_value)
}

data "aws_iam_policy_document" "secret_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets",
    ]
    resources = [
      aws_secretsmanager_secret.secret.arn,
    ]
  }
}

resource "aws_iam_policy" "secret_policy" {
  name   = "${var.secret_name}-policy"
  policy = data.aws_iam_policy_document.secret_policy_document.json
}
