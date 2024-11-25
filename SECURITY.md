# Security Policy

## Supported Versions

We aim to support the most recent versions of our Terraform modules. Make sure to regularly update to the latest
version.

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.x   | :x:                |

## Reporting a Vulnerability

If you discover any security vulnerabilities, please report them securely via email to `security@conversadocs.com`.
Please include as much information as possible to help us understand the nature of the vulnerability.

## Best Practices

### Secrets Management

- Use encrypted S3 buckets, HashiCorp Vault, or AWS Secrets Manager to store sensitive information.
- Avoid hardcoding secrets and credentials directly in Terraform files.

### Code Review

- Ensure all code changes are peer-reviewed.
- Use pull requests for all changes to validate before merging into main branches.

### Least Privilege

- Grant the minimum required IAM permissions to each resource.
- Use IAM roles and policies to limit access based on the principle of least privilege.

### Network Security

- Use security groups and network ACLs to restrict traffic to and from your VPC.
- Enable VPC flow logs to monitor traffic and identify potential breaches.

### Encryption

- Enable encryption at rest for all AWS services that support it.
- Use HTTPS for all data in transit.

### Resource Policies

- Implement resource tags for better management and security auditing.
- Use configuration rules and continuous compliance tools like AWS Config or Terraform Sentinel.

### Regular Audits

- Conduct regular security audits and vulnerability scans.
- Ensure Terraform state files are securely stored and access controlled.

### Automated Testing

- Implement automated tests (e.g., using Terratest) to verify the security of Terraform code.

## Contact

For other security concerns or inquiries, contact us at `security@conversadocs.com`.
