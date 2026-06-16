---
name: recurring-findings
description: Security patterns that recur in this project's Terraform — use as a quick-check list on future audits
metadata:
  type: feedback
---

Patterns confirmed present across audits (first: 2026-06-12, latest: 2026-06-16, seventh audit: 2026-06-16):

1. **No explicit S3 encryption block** — FIXED as of 2026-06-12: aws_s3_bucket_server_side_encryption_configuration with aws:kms and bucket_key_enabled = true is present. However, no aws_kms_key resource exists — uses AWS-managed key with no rotation control (CMK gap still open).
2. **No S3 access logging** — CloudFront access logs and S3 server access logs both absent. Persists as of 2026-06-16.
3. **No S3 versioning** — FIXED as of 2026-06-16: aws_s3_bucket_versioning with status = "Enabled" is now present. MFA delete is still not configured.
4. **CloudFront missing response headers policy** — no Content-Security-Policy, X-Frame-Options, Strict-Transport-Security, X-Content-Type-Options configured. Persists as of 2026-06-16.
5. **CloudFront TLS minimum protocol not hardened** — using cloudfront_default_certificate with no minimum_protocol_version set; defaults to TLSv1 which is insecure. Persists as of 2026-06-16.
6. **State file in repo** — terraform.tfstate.backup still committed and tracked in git; exposes account ID 749213211172 and IAM username a-stephen (AIDA244EWLISBCBFQBOWN). .gitignore excludes new writes but history is not clean. Persists as of 2026-06-16.
7. **force_destroy = true on production S3 bucket** — allows one-command accidental data deletion. Persists as of 2026-06-16.
8. **Backend partially enabled with syntax error** — backend.tf now exists and is uncommented (fixed from prior audit) but contains a stray token "kdjk" on line 23 that will break terraform init. Account ID hardcoded in bucket name. Seventh audit 2026-06-16.
9. **OIDC IAM role missing** — no GitHub Actions OIDC role in Terraform despite CI/CD architecture requiring it. Persists as of 2026-06-16.
10. **CloudFront WAF absent** — no aws_wafv2_web_acl_association; public distribution has no rate limiting or managed rule groups. Persists as of 2026-06-16.
11. **CloudFront 404 masking** — custom_error_response maps HTTP 404 to response_code 200; this hides broken links from monitoring and CDN cache correctly serves stale 404 pages as 200s.

**Why:** These findings appeared consistently in the first review of this codebase.

**How to apply:** On every future audit, check all 10 patterns above before looking for novel issues.
