---
name: portfolio-site-cost-analysis
description: AWS cost optimization findings for static portfolio site on S3 + CloudFront
metadata:
  type: project
---

## Infrastructure Overview
- Static HTML/CSS portfolio site (single-page, pure HTML5 + CSS3, no JS)
- Hosted on private S3 bucket with CloudFront CDN
- Terraform state in S3 backend with DynamoDB locking
- GitHub Actions OIDC CI/CD for deployments
- Region: eu-west-1
- Environment: production

## Cost Patterns & Decisions

**CloudFront Price Class: PriceClass_200**
- Covers ~99 countries (most expensive after PriceClass_All)
- For a portfolio site, PriceClass_100 (50+ countries, lower-cost edge locations) is typically sufficient
- Potential savings: ~30% on data transfer costs if traffic is primarily North America/EU

**S3 Storage Class: Standard (default)**
- No lifecycle policies configured
- Portfolio assets (HTML, CSS, images) are static and rarely change
- S3 Intelligent-Tiering not needed for rarely-accessed content, but S3 Standard is appropriate for active site content
- No versioning, no logging, no replication configured (correct for this use case)

**CloudFront Caching TTL: CachingOptimized policy**
- Using AWS managed CachingOptimized policy (658327ea-f89d-4fab-a63d-7e88639e58f6)
- This policy caches aggressively with long default TTLs (31536000s = 1 year for immutable assets)
- Good for static sites, minimizes origin requests
- Error caching TTL: 300s (5 min) for 404 → reasonable

**Missing Cost Optimizations:**
1. No S3 access logs - cost is negligible for static site
2. No CloudFront access logs - could be enabled for debugging, but adds S3 cost
3. No CloudFront origin request tracking - not needed for this scale
4. DynamoDB state locking commented out - good (avoids unnecessary DynamoDB provisioned capacity)
5. No WAF or Shield Advanced - appropriate (portfolio site has low attack surface)

## Estimated Monthly Costs (Baseline, assuming ~10GB storage, 100k requests/month)
- S3 Storage: ~$0.23 (10GB × $0.023/GB)
- S3 API Calls: <$0.01 (minimal)
- CloudFront Data Transfer: ~$0.50-2.00 depending on geographic distribution
- CloudFront Requests: ~$0.01 (100k × $0.0075/10k for GET)
- **Total: ~$1-3/month** (very low volume)

## High-Impact Optimization
**Recommendation: Reduce CloudFront PriceClass from 200 → 100**
- Removes expensive edge locations in less common regions
- Maintains coverage for US, Canada, EU, Japan, Australia
- If traffic is primarily North America/EU: ~30% savings on data transfer
- For baseline (~$0.50-2.00/month): save ~$0.15-0.60/month
- Impact: LOW in absolute dollars but HIGH in percentage terms (30% reduction)
