# Security Auditor Memory

- [Project Infrastructure Profile](project-infra-profile.md) — Static site on S3+CloudFront; OIDC IAM role not yet in Terraform; state backend commented out
- [Recurring Findings Patterns](recurring-findings.md) — Patterns seen across audits: missing S3 encryption block, no CloudFront security headers, TLS policy gaps, state file leaks account ID
