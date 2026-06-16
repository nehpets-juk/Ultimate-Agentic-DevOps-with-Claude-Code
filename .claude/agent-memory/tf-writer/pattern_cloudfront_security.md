---
name: pattern-cloudfront-security
description: CloudFront security hardening patterns used in this project — TLS version pinning and response headers policy
metadata:
  type: project
---

Two security controls are applied to every CloudFront distribution in this project:

**TLS minimum version (viewer_certificate)**

Even when `cloudfront_default_certificate = true` (no ACM cert yet), always set:

```hcl
viewer_certificate {
  cloudfront_default_certificate = true
  minimum_protocol_version       = "TLSv1.2_2021"
  ssl_support_method             = "sni-only"
}
```

**Why:** Documents intent and is ready to enforce the moment an ACM cert is swapped in. CloudFront silently ignores these fields when the default cert is active, but they become load-bearing after cert migration.

**How to apply:** Include both fields on every `viewer_certificate` block, even before a custom domain exists.

---

**Response headers policy (aws_cloudfront_response_headers_policy)**

Define `aws_cloudfront_response_headers_policy.security_headers` in the CloudFront section (before the distribution resource) and reference it from `default_cache_behavior`:

```hcl
response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
```

The policy enforces: X-Content-Type-Options, X-Frame-Options (DENY), Referrer-Policy, HSTS (1yr + subdomains + preload), CSP, and X-XSS-Protection.

CSP for this project: `default-src 'self'; script-src 'none'; style-src 'self'; img-src 'self' data:; object-src 'none'; base-uri 'self'; frame-ancestors 'none';`

**Why:** Static HTML/CSS site with no JS or external resources — a strict no-script CSP is safe and correct. HSTS preload requires `ssl_support_method = "sni-only"` (see above).

**How to apply:** Add this resource to any new CloudFront distribution. If the site ever adds JS or external fonts/images, the CSP `script-src` and `img-src` directives will need to be widened.
