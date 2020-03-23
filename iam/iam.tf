resource "aws_iam_role" "elasticsearch" {
  name               = "elk_role"
  assume_role_policy = file("${path.module}/policies/role.json")
}

resource "aws_iam_role_policy" "elasticsearch" {
  name     = "elk_policy"
  policy   = file("${path.module}/policies/policy.json")
  role     = aws_iam_role.elasticsearch.id
}

resource "aws_iam_instance_profile" "elasticsearch" {
  name = "elk_profile"
  path = "/"
  role = aws_iam_role.elasticsearch.name
}