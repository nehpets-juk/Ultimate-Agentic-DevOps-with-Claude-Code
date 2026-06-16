---
name: project-backend-hcl-pattern
description: This project uses a gitignored backend.hcl partial config to keep the S3 backend bucket name and region out of version control
metadata:
  type: project
---

The S3 backend in `terraform/backend.tf` intentionally omits `bucket` and `region`. Those sensitive values live in `terraform/backend.hcl`, which is gitignored.

Developers must run:
  terraform init -backend-config=backend.hcl

**Why:** The bucket name embeds the AWS account ID (`forest-statet-749213211172s`). Committing it leaks the account ID to git history.

**How to apply:** Never add `bucket` or `region` back to `backend.tf`. If scaffolding or modifying the backend block, keep only `key`, `encrypt`, and `use_lockfile` in the HCL file checked into git, and remind the user to populate `backend.hcl`.
