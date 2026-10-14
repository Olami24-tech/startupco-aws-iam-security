resource "aws_iam_group" "developers" {
  name = "StartupCo-TF-Developers"
}

resource "aws_iam_group" "operations" {
  name = "StartupCo-TF-Operations"
}

resource "aws_iam_group" "finance" {
  name = "StartupCo-TF-Finance"
}

resource "aws_iam_group" "analysts" {
  name = "StartupCo-TF-Analysts"
}