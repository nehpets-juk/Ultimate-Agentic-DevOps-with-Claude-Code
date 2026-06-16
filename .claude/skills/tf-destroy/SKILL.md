---
name: tf-destroy
description: Run terraform destroy to safely tear down all AWS infrastructure. This is a destructive action and should only be used when you want to completely remove all resources. Requires confirmation before proceeding.
allowed-tools: Bash, Read, Write
disable-model-invocation: true
---

Run `cd terraform && terraform destroy` and verify the results.

After apply completes:
- [ ] Confirm that all resources have been destroyed (CloudFront distribution deleted, S3 bucket removed)
- [ ] Report any errors and suggest fixes

If apply fails, do NOT retry automatically. Show the error and wait for instructions.