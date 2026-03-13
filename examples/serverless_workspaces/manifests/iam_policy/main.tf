resource "aws_iam_policy" "iam_policy" {
  name   = var.policy_name
  policy = var.iam_policy_json_document
}
