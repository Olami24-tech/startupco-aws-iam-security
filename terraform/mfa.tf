# MultiFactor Authentication Policy

data "aws_iam_policy_document" "mfa_enforcement" {
  statement {
    sid    = "DenyActionsWithoutMFA"
    effect = "Deny"

    not_actions = [
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListVirtualMFADevices"
    ]

    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}


data "aws_iam_policy_document" "mfa_self_service" {
  statement {
    sid    = "ViewOwnMFAStatus"
    effect = "Allow"

    actions = [
      "iam:GetUser",
      "iam:ListMFADevices"
    ]

    resources = [
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "CreateOwnVirtualMFADevice"
    effect = "Allow"

    actions = [
      "iam:CreateVirtualMFADevice"
    ]

    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}"
    ]
  }

  statement {
    sid    = "EnableOwnMFADevice"
    effect = "Allow"

    actions = [
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]

    resources = [
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "ListVirtualMFADevices"
    effect = "Allow"

    actions = [
      "iam:ListVirtualMFADevices"
    ]

    resources = ["*"]
  }
}


locals {
  startupco_groups = {
    developers = aws_iam_group.developers.name
    operations = aws_iam_group.operations.name
    finance    = aws_iam_group.finance.name
    analysts   = aws_iam_group.analysts.name
  }
}

resource "aws_iam_group_policy" "mfa_enforcement" {
  for_each = local.startupco_groups

  name   = "StartupCo-TF-MFAEnforcement"
  group  = each.value
  policy = data.aws_iam_policy_document.mfa_enforcement.json
}

resource "aws_iam_group_policy" "mfa_self_service" {
  for_each = local.startupco_groups

  name   = "StartupCo-TF-MFASelfService"
  group  = each.value
  policy = data.aws_iam_policy_document.mfa_self_service.json
}
