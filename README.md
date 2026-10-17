# StartupCo AWS IAM Security Project

## Project Overview

This project demonstrates the implementation of AWS Identity and Access Management (IAM) security controls for a fictional company, StartupCo.

The solution uses two Infrastructure as Code (IaC) technologies:

- **AWS CloudFormation** — YAML-based infrastructure provisioning.
- **Terraform** — declarative infrastructure provisioning using HashiCorp Configuration Language (HCL).

The project focuses on role-based access control (RBAC), least-privilege permissions, multi-factor authentication (MFA) enforcement, and infrastructure validation.


## Architecture

The IAM architecture supports four departments:

| Department | Permissions |
|---|---|
| Developers | EC2 instance operations, S3 object management in a designated bucket, and CloudWatch Logs read access |
| Operations | EC2 administration, CloudWatch management, selected Systems Manager actions, and RDS management |
| Finance | Cost Explorer, AWS Budgets, and AWS-managed ReadOnlyAccess |
| Analysts | Read-only S3 object access in a designated bucket and RDS metadata access |

Each department has its own IAM group, representative IAM user, and permissions policy.
### AWS IAM Architecture Diagram

The following diagram illustrates the IAM group structure, department-specific permissions, and security controls implemented using Terraform and CloudFormation.

[View the AWS IAM Architecture Diagram](diagrams/architecture.md)

## Security Controls

### Least-Privilege Access

Permissions are assigned through IAM groups rather than individually to users.

The Developer and Analyst S3 policies restrict access to a specific demonstration bucket. Analysts cannot upload or delete S3 objects, while Developers can manage objects in the designated bucket.

### Multi-Factor Authentication

The Terraform implementation includes centralised MFA enforcement policies attached to all four IAM groups.

MFA self-service policies provide permissions for users to register virtual MFA devices.

**Note:** MFA enforcement was tested using the AWS IAM Policy Simulator. Live MFA enrolment for all Terraform users has not been completed.

### Password Security

The AWS account's IAM password policy was configured separately using AWS CLI rather than managed by the Terraform configuration.

The policy includes minimum password length and complexity requirements.

## Infrastructure as Code

### CloudFormation

The `cloudformation/iam.yaml` template provisions IAM groups, users, department permissions, and MFA enforcement.

### Terraform

The `terraform/` directory contains:

- `main.tf` — IAM groups.
- `user.tf` — IAM users and group memberships.
- `policies.tf` — department-specific IAM permissions.
- `mfa.tf` — MFA enforcement and self-service policies.
- `provider.tf` — Terraform and AWS provider configuration.

Terraform manages 25 IAM resources in the implementation.

## Validation and Security Testing

### Security Testing Report

A detailed record of the IAM Policy Simulator tests, expected and actual results, MFA enforcement verification, and testing limitations is available here:

[View IAM Security Testing Report](docs/security-testing.md)
The project was validated using Terraform CLI commands and the AWS IAM Policy Simulator.

### Terraform Validation

- `terraform fmt` — configuration formatting.
- `terraform validate` — configuration validation.
- `terraform plan` — proposed infrastructure changes.
- `terraform apply` — deployment.
- Final `terraform plan` — confirmed no configuration drift.

### IAM Permission Testing

| Role | Verified simulated behaviour |
|---|---|
| Analyst | S3 object read allowed; upload and deletion denied; RDS metadata read allowed |
| Developer | EC2 operations allowed; designated S3 object operations allowed; CloudWatch Logs read allowed; log group deletion denied |
| Operations | EC2, CloudWatch Logs, Systems Manager and RDS actions allowed; S3 object deletion denied |
| Finance | Cost Explorer and AWS Budgets actions allowed; EC2 describe allowed; EC2 termination and S3 deletion denied |

MFA-enabled and MFA-disabled contexts were also evaluated in the simulator.

These tests validate IAM identity-policy behaviour under the simulated conditions. They do not replace live end-to-end access testing.

## Repository Structure

```text
startupco-aws-iam-security/
├── cloudformation/
│   └── iam.yaml
├── terraform/
│   ├── main.tf
│   ├── user.tf
│   ├── policies.tf
│   ├── mfa.tf
│   ├── provider.tf
│   └── .terraform.lock.hcl
├── .gitignore
└── README.md
```

## Skills Demonstrated

- AWS IAM users, groups, and policies
- Role-based access control
- Least-privilege security design
- MFA enforcement and IAM policy conditions
- AWS CloudFormation
- Terraform Infrastructure as Code
- AWS CLI
- IAM Policy Simulator
- Git and GitHub

## Security Considerations

Terraform state files, credentials, environment secrets, and provider download directories are excluded from version control.

The project uses a fictional organisation and demonstration IAM identities.

Some permissions, particularly Operations administration and the AWS-managed ReadOnlyAccess policy, are intentionally broad for the demonstration and would require further scoping and review in a production environment.
