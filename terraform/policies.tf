# Developers Team IAM Policy

data "aws_iam_policy_document" "developer" {
  statement {
    sid    = "EC2Describe"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "EC2InstanceManagement"
    effect = "Allow"

    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3BucketListing"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::startupco-demo-764666066507"
    ]
  }

  statement {
    sid    = "S3ObjectManagement"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::startupco-demo-764666066507/*"
    ]
  }

  statement {
    sid    = "CloudWatchLogsReadOnly"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "developer" {
  name   = "StartupCo-TF-DeveloperPolicy"
  group  = aws_iam_group.developers.name
  policy = data.aws_iam_policy_document.developer.json
}


# Operations Team IAM Policy

data "aws_iam_policy_document" "operations" {
  statement {
    sid    = "EC2Management"
    effect = "Allow"

    actions = [
      "ec2:*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CloudWatchManagement"
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "logs:*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "SystemsManagerAccess"
    effect = "Allow"

    actions = [
      "ssm:DescribeInstanceInformation",
      "ssm:GetCommandInvocation",
      "ssm:ListCommandInvocations",
      "ssm:ListCommands",
      "ssm:SendCommand"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "RDSManagement"
    effect = "Allow"

    actions = [
      "rds:RebootDBInstance",
      "rds:ModifyDBInstance",
      "rds:CreateDBInstance",
      "rds:DeleteDBSnapshot",
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:DescribeDBSnapshots",
      "rds:StartDBInstance",
      "rds:StopDBInstance"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "operations" {
  name   = "StartupCo-TF-OperationsPolicy"
  group  = aws_iam_group.operations.name
  policy = data.aws_iam_policy_document.operations.json
}


# Finance Team IAM Policy

data "aws_iam_policy_document" "finance" {
  statement {
    sid    = "BillingAndCostManagement"
    effect = "Allow"

    actions = [
      "ce:*",
      "budgets:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "finance" {
  name   = "StartupCo-TF-FinancePolicy"
  group  = aws_iam_group.finance.name
  policy = data.aws_iam_policy_document.finance.json
}

resource "aws_iam_group_policy_attachment" "finance_readonly" {
  group      = aws_iam_group.finance.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Analyst Team IAM Policy

data "aws_iam_policy_document" "analyst" {
  statement {
    sid    = "S3BucketListing"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::startupco-demo-764666066507"
    ]
  }

  statement {
    sid    = "S3ObjectReadOnly"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::startupco-demo-764666066507/*"
    ]
  }

  statement {
    sid    = "RDSReadOnly"
    effect = "Allow"

    actions = [
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:DescribeDBSnapshots",
      "rds:DescribeDBClusterSnapshots"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "analyst" {
  name   = "StartupCo-TF-AnalystPolicy"
  group  = aws_iam_group.analysts.name
  policy = data.aws_iam_policy_document.analyst.json
}
