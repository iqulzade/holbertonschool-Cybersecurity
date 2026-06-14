# Passive Reconnaissance Report — holbertonschool.com

**Target Domain:** `holbertonschool.com`
**Methodology:** Passive reconnaissance using Shodan (InternetDB), DNS enumeration, RDNS lookups, WHOIS/RDAP inference, and CNAME chain analysis.
**Date:** 2026-06-14

---

## Table of Contents

1. [DNS Records](#1-dns-records)
2. [Subdomain Enumeration](#2-subdomain-enumeration)
3. [IP Ranges](#3-ip-ranges)
4. [Technologies & Frameworks](#4-technologies--frameworks)
5. [Email & Security Records](#5-email--security-records)
6. [Infrastructure Summary](#6-infrastructure-summary)

---

## 1. DNS Records

### A Record (Root Domain)

| Record | Type | Value |
|--------|------|-------|
| holbertonschool.com | A | `198.202.211.1` |

### Name Servers (NS) — AWS Route 53

| NS Record |
|-----------|
| `ns-1244.awsdns-27.org` |
| `ns-1991.awsdns-56.co.uk` |
| `ns-343.awsdns-42.com` |
| `ns-957.awsdns-55.net` |

> **Finding:** The domain uses **Amazon Route 53** as its authoritative DNS provider, indicating AWS-centric infrastructure.

### MX Records — Google Workspace

| Priority | Mail Server |
|----------|-------------|
| 1 | `aspmx.l.google.com` |
| 5 | `alt1.aspmx.l.google.com` |
| 5 | `alt2.aspmx.l.google.com` |
| 10 | `alt3.aspmx.l.google.com` |
| 10 | `alt4.aspmx.l.google.com` |

> **Finding:** Email is handled entirely by **Google Workspace (Gmail)** — all MX records point to Google's servers.

### SOA Record

| Field | Value |
|-------|-------|
| Primary NS | `ns-957.awsdns-55.net` |
| Responsible | `awsdns-hostmaster.amazon.com` |
| Serial | 1 |
| Refresh | 7200 |
| Retry | 900 |
| Expire | 1209600 |
| Minimum TTL | 86400 |

---

## 2. Subdomain Enumeration

Discovered subdomains via DNS brute-force and CNAME resolution:

| Subdomain | Resolved IP | CNAME Target | Notes |
|-----------|------------|--------------|-------|
| `holbertonschool.com` | `198.202.211.1` | — | Root domain |
| `www.holbertonschool.com` | `198.202.211.1` | `cdn.webflow.com` | Main website via Webflow CDN |
| `blog.holbertonschool.com` | `192.0.78.230` | — | WordPress.com VIP |
| `apply.holbertonschool.com` | `15.236.2.28` | `hbtn-website-prod.eu-west-3.elasticbeanstalk.com` | Applications portal — AWS Elastic Beanstalk (Paris) |
| `fr.holbertonschool.com` | `18.211.166.153` | `proxy-ssl.webflow.com` | French site — Webflow proxy on AWS |
| `v2.holbertonschool.com` | `34.203.198.145` | — | Backend API / v2 platform on AWS EC2 |
| `mail.holbertonschool.com` | `18.154.101.32` | `d2dclf02a1rpk.cloudfront.net` | Mail CDN layer via CloudFront |
| `assets.holbertonschool.com` | `18.160.143.12` | `d15pj990prg69j.cloudfront.net` | Static assets via CloudFront |
| `support.holbertonschool.com` | `216.198.53.2` | `holbertonschool.zendesk.com` | Support platform — Zendesk |
| `help.holbertonschool.com` | `198.202.211.1` | — | Alias to root domain (Webflow) |
| `test.holbertonschool.com` | `8.8.8.8` | — | ⚠️ Points to Google DNS — likely misconfigured or placeholder |

**Total subdomains discovered: 11**

---

## 3. IP Ranges

All discovered IPs and their associated network ranges, inferred from RDNS patterns and known cloud provider CIDR allocations:

| IP Address | CIDR Range | Organization | Region | Subdomain(s) |
|------------|-----------|--------------|--------|--------------|
| `198.202.211.1` | `198.202.208.0/21` | Webflow, Inc. | USA | holbertonschool.com, www, help |
| `192.0.78.230` | `192.0.78.0/24` | Automattic Inc. (WordPress.com VIP) | USA | blog |
| `15.236.2.28` | `15.236.0.0/15` | Amazon Web Services (EC2) | eu-west-3 — Paris, France | apply |
| `18.211.166.153` | `18.208.0.0/13` | Amazon Web Services (EC2) | us-east-1 — N. Virginia, USA | fr |
| `18.154.101.32` | `18.154.0.0/15` | Amazon Web Services (CloudFront) | Denver POP (den52) | mail |
| `18.160.143.12` | `18.160.0.0/15` | Amazon Web Services (CloudFront) | Denver POP (den52) | assets |
| `34.203.198.145` | `34.192.0.0/12` | Amazon Web Services (EC2) | us-east-1 — N. Virginia, USA | v2 |
| `216.198.53.2` | `216.198.48.0/20` | Zendesk, Inc. | USA | support |

### Consolidated IP Ranges

```
198.202.208.0/21   → Webflow CDN (main site)
192.0.78.0/24      → WordPress.com VIP (blog)
15.236.0.0/15      → AWS EC2 eu-west-3 (Paris) — apply portal
18.154.0.0/15      → AWS CloudFront CDN — mail assets
18.160.0.0/15      → AWS CloudFront CDN — static assets
18.208.0.0/13      → AWS EC2 us-east-1 — Webflow proxy (fr site)
34.192.0.0/12      → AWS EC2 us-east-1 — v2 backend
216.198.48.0/20    → Zendesk Inc. — support platform
```

---

## 4. Technologies & Frameworks

### Per-Subdomain Technology Fingerprint

#### `holbertonschool.com` / `www.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| Website Builder / CMS | **Webflow** |
| CDN | Webflow CDN (`cdn.webflow.com`) |
| DNS | Amazon Route 53 |
| Email | Google Workspace |

#### `blog.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| CMS | **WordPress.com VIP** |
| Hosting | Automattic (192.0.78.0/24 — known WP.com VIP range) |

#### `apply.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| Platform | **AWS Elastic Beanstalk** |
| Cloud | Amazon Web Services — EC2 (eu-west-3 / Paris) |
| App Name | `hbtn-website-prod` (identified via CNAME) |

#### `fr.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| Website Builder | **Webflow** (via `proxy-ssl.webflow.com`) |
| Proxy / CDN | AWS EC2 us-east-1 acting as Webflow SSL proxy |

#### `v2.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| Hosting | **AWS EC2** (us-east-1) |
| Purpose | Backend API / v2 platform (inferred from subdomain naming) |

#### `mail.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| CDN | **AWS CloudFront** (`d2dclf02a1rpk.cloudfront.net`) |
| POP | Denver (den52) |
| Purpose | Email marketing / transactional mail asset CDN |

#### `assets.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| CDN | **AWS CloudFront** (`d15pj990prg69j.cloudfront.net`) |
| Backend (likely) | AWS S3 (standard CloudFront origin) |
| POP | Denver (den52) |
| Purpose | Static asset delivery (images, JS, CSS, etc.) |

#### `support.holbertonschool.com`
| Category | Technology |
|----------|-----------|
| Support Platform | **Zendesk** |
| CNAME | `holbertonschool.zendesk.com` |
| IP Block | Zendesk Inc. (216.198.48.0/20) |

---

## 5. Email & Security Records

### DMARC Policy

Two DMARC records found (dual-policy configuration):

```
v=DMARC1; p=none; rua=mailto:rua@dmarc.brevo.com
v=DMARC1; p=none; rua=mailto:noreply@holbertonschool.com
```

| Field | Value |
|-------|-------|
| Policy | `none` (monitor only — no enforcement) |
| Aggregate Reports | Sent to **Brevo** (formerly Sendinblue) and internal address |
| Email Provider Hint | **Brevo** used for transactional/marketing email (DMARC RUA) |

> ⚠️ **Finding:** DMARC policy is `p=none`, meaning emails failing DMARC are **not rejected or quarantined**. This indicates a potential email spoofing risk — the domain could be impersonated without being blocked by receiving mail servers.

---

## 6. Infrastructure Summary

### Cloud & Hosting Providers

| Provider | Services Used |
|----------|--------------|
| **Amazon Web Services (AWS)** | EC2 (eu-west-3, us-east-1), CloudFront CDN, Elastic Beanstalk, Route 53 DNS |
| **Webflow** | Main website CMS and CDN, French locale proxy |
| **WordPress.com VIP** | Blog hosting (Automattic infrastructure) |
| **Google** | Workspace (email via Gmail MX) |
| **Zendesk** | Customer support platform |
| **Brevo (Sendinblue)** | Transactional/marketing email, DMARC reporting |

### Observations & Findings

1. **Heavy AWS reliance:** The majority of dynamic infrastructure runs on AWS — EC2 instances in both `eu-west-3` (Paris) and `us-east-1` (N. Virginia), plus CloudFront for CDN. This suggests AWS as the primary cloud vendor.

2. **Webflow for frontend:** The main website and French locale both use Webflow as the CMS/website builder, with AWS acting as the reverse proxy layer for SSL termination on the French site.

3. **Separated apply portal:** `apply.holbertonschool.com` runs a dedicated `hbtn-website-prod` application on AWS Elastic Beanstalk in the Paris region — likely a custom-built enrollment/application web app.

4. **Test subdomain misconfiguration:** `test.holbertonschool.com` resolves to `8.8.8.8` (Google Public DNS), which is almost certainly a DNS misconfiguration or an abandoned record — not a legitimate endpoint.

5. **DMARC not enforced:** The `p=none` DMARC policy means spoofed emails from `@holbertonschool.com` would not be automatically blocked. This is a notable finding for email security posture.

6. **No IPv6:** No AAAA records found for any subdomain — the entire domain is IPv4-only.

7. **No WAF/CDN masking on EC2 instances:** Direct EC2 IPs are exposed via RDNS for `apply.holbertonschool.com`, `fr.holbertonschool.com`, and `v2.holbertonschool.com` — the actual server IPs are not hidden behind a WAF or CDN.

---

*Report generated via passive DNS enumeration and open-source intelligence (OSINT) — no active scanning or intrusive probing was performed.*
