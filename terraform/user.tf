resource "aws_iam_user" "developer" {
  name = "startupco-tf-developer"
}

resource "aws_iam_user" "operations" {
  name = "startupco-tf-operations"
}

resource "aws_iam_user" "finance" {
  name = "startupco-tf-finance"
}

resource "aws_iam_user" "analyst" {
  name = "startupco-tf-analyst"
}

resource "aws_iam_user_group_membership" "developer" {
  user   = aws_iam_user.developer.name
  groups = [aws_iam_group.developers.name]
}

resource "aws_iam_user_group_membership" "operations" {
  user   = aws_iam_user.operations.name
  groups = [aws_iam_group.operations.name]
}

resource "aws_iam_user_group_membership" "finance" {
  user   = aws_iam_user.finance.name
  groups = [aws_iam_group.finance.name]
}

resource "aws_iam_user_group_membership" "analyst" {
  user   = aws_iam_user.analyst.name
  groups = [aws_iam_group.analysts.name]
}