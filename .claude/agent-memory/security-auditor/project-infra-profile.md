---
name: project-infra-profile
description: Core infrastructure shape of this project — what exists in Terraform vs what is missing
metadata:
  type: project
---

Static portfolio site deployed to AWS S3 + CloudFront (eu-west-1).

Key facts as of 2026-06-16 (verified in seventh audit — latest commit 8e49e39, main.tf modified but unstaged):
- main.tf contains: S3 bucket, public access block, bucket policy, OAC, CloudFront distribution, aws_s3_bucket_versioning
- S3 now has explicit aws_s3_bucket_server_side_encryption_configuration using aws:kms with bucket_key_enabled = true (FIXED from prior audit)
- aws_s3_bucket_versioning.site is now present with status = "Enabled" (FIXED from prior audit)
- CloudFront viewer_protocol_policy = "redirect-to-https" is present (FIXED from prior audit)
- viewer_certificate block uses cloudfront_default_certificate = true with NO minimum_protocol_version — still defaults to TLSv1 (UNFIXED)
- force_destroy = true on aws_s3_bucket.site production bucket (UNFIXED)
- KMS key for S3 encryption uses AWS-managed key (no aws_kms_key resource) — no key rotation or customer control (UNFIXED)
- OIDC GitHub Actions IAM role still has NO Terraform resource — missing from codebase (UNFIXED)
- backend.tf now exists and is UNCOMMENTED with a real bucket name (forest-statet-749213211172) and use_lockfile=true, but has a stray syntax error on line 23 ("kdjk") and uses use_lockfile instead of dynamodb_table (new Terraform 1.10+ feature, verify version). Account ID is hardcoded in bucket name.
- No dynamodb_table argument in backend.tf — uses newer use_lockfile = true (requires Terraform >= 1.10 and S3 native locking)
- terraform.tfstate (serial 23, empty resources) and terraform.tfstate.backup (serial 20, exposes account ID 749213211172 and IAM user a-stephen / AIDA244EWLISBCBFQBOWN) are both tracked in git
- .gitignore correctly excludes *.tfstate* going forward but both files remain in git history and are still untracked per git status
- No aws_s3_bucket_logging, no aws_cloudfront_response_headers_policy, no aws_wafv2_web_acl_association (UNFIXED)
- NEW: 404 error response returns HTTP 200 — hides real 404s from monitoring tools

**Why:** Understanding what is and is not in Terraform prevents false negatives (assuming OIDC role exists and is secure when it does not).

**How to apply:** When auditing, flag the missing OIDC and state-backend resources as gaps. When generating Terraform, scaffold those missing pieces.
