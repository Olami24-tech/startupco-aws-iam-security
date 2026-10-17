
## Testing Methodology

Testing was performed using the AWS IAM Policy Simulator against the Terraform-managed IAM policies.

The tests evaluated:
- Allowed actions for each department.
- Denied actions outside departmental permissions.
- MFA-enabled and MFA-disabled request contexts.

These are simulated IAM permission tests, not live user sign-in or end-to-end service access tests.

## Role-Based Access Control Test Results

| Department | AWS Action | Expected Result | Simulator Result |
|---|---|---|---|
| Developers | ec2:StartInstances | Allow | Allowed |
| Developers | ec2:DescribeInstances | Allow | Allowed |
| Developers | s3:PutObject (demo bucket) | Allow | Allowed |
| Developers | s3:CreateBucket | Deny | Denied |
| Developers | logs:GetLogEvents | Allow | Allowed |
| Developers | logs:DeleteLogGroup | Deny | Denied |
| Operations | ec2:StartInstances | Allow | Allowed |
| Operations | ssm:SendCommand | Allow | Allowed |
| Operations | rds:RebootDBInstance | Allow | Allowed |
| Operations | s3:DeleteObject | Deny | Denied |
| Finance | ce:GetCostAndUsage | Allow | Allowed |
| Finance | budgets:ViewBudget | Allow | Allowed |
| Finance | ec2:DescribeInstances | Allow | Allowed |
| Finance | ec2:TerminateInstances | Deny | Denied |
| Analysts | s3:GetObject (demo bucket) | Allow | Allowed |
| Analysts | s3:PutObject (demo bucket) | Deny | Denied |
| Analysts | s3:DeleteObject (demo bucket) | Deny | Denied |
| Analysts | rds:DescribeDBInstances | Allow | Allowed |

All results listed above were obtained with MFA enabled in the simulated request context.

## MFA Enforcement Testing

The Analyst policies were also tested using different MFA request contexts.

| MFA Context | Action | Simulator Result |
|---|---|---|
| MFA disabled | s3:GetObject | Denied |
| MFA disabled | s3:PutObject | Denied |
| MFA disabled | rds:DescribeDBInstances | Denied |
| MFA enabled | s3:GetObject (demo bucket) | Allowed |
| MFA enabled | s3:PutObject (demo bucket) | Denied |
| MFA enabled | rds:DescribeDBInstances | Allowed |

This demonstrates that the simulated IAM policy evaluation blocks the tested actions without MFA and applies departmental permissions when MFA is present.

## Additional Verification

- Terraform deployment completed successfully.
- Terraform managed 25 IAM resources.
- A subsequent `terraform plan` reported no infrastructure changes.
- The Finance group's AWS-managed `ReadOnlyAccess` attachment was verified using AWS CLI.

## Testing Limitations

- Tests were performed using IAM Policy Simulator rather than signing in as each Terraform IAM user.
- Live MFA enrolment was not completed for all Terraform users.
- Simulator results do not guarantee access when additional AWS controls, such as service control policies or resource policies, apply.
- RDS metadata permissions do not grant SQL query access to database contents.

## Conclusion

The tested IAM policies produced the expected simulated allow and deny decisions for the four departments.

The results support the project's role-based access control and MFA enforcement design, subject to the testing limitations documented above.
# StartupCo IAM Security Testing

This document records the IAM Policy Simulator tests performed against the Terraform-managed IAM policies.

Testing covers role-based access control, least-privilege permissions, and MFA enforcement.
