# Security Policy

> [CUSTOMIZE THIS FILE] Document your project's security requirements so the security-auditor agent has accurate standards to enforce.

## Authentication Requirements

- **Session duration:** [e.g., 7 days with sliding expiration / 1 hour hard expiry]
- **Multi-factor auth:** [Required / Optional / Not implemented]
- **Password requirements:** [e.g., min 12 chars, complexity rules]
- **Brute force protection:** [e.g., account lockout after 5 failed attempts, rate limiting on auth endpoints]

## Authorization Model

- **Pattern:** [e.g., RBAC / ABAC / simple owner-check]
- **Roles:** [List roles and their permissions, or link to a schema/permissions.md]
- **Default permission:** [e.g., deny-all — explicit grants required]

**Authorization rule:**
> Every data access must verify the requesting user owns or has explicit access to the resource. Never rely on the caller having the correct ID — always check in the database.

## Input Validation Rules

All user-supplied input must be validated at the API boundary before use:

1. **Type checking:** Reject unexpected types
2. **Length limits:** Enforce max lengths on all string fields
3. **Format validation:** Email, phone, URL, UUID — use regex or library validators
4. **Allowlist for enums:** Only accept known values for status/type fields
5. **Numeric bounds:** Min/max on all numeric inputs

**Never:**
- Pass unsanitized input to SQL queries (use parameterized queries or ORM)
- Pass unsanitized input to shell commands
- Render unsanitized input as HTML (use framework escaping)

## Secrets Management

**Rules:**
- Secrets live only in environment variables — never in source code or config files
- `.env` files are gitignored — `.env.example` with placeholder values is checked in
- Secrets in CI/CD are injected from a secret store (e.g., GitHub Secrets, Vault, AWS SSM)
- Production secrets rotate on a schedule: [e.g., quarterly]

**What counts as a secret:** API keys, database credentials, JWT signing keys, OAuth secrets, webhook signing secrets, any token that grants access.

**See `.claude/rules/env.md` for the full list of environment variables.**

## Data Privacy

- **PII fields:** [List fields containing PII — e.g., email, name, IP address, payment info]
- **Logging:** Never log PII or secrets. Log user IDs only, not user data.
- **At-rest encryption:** [Describe encryption for sensitive data fields]
- **Data retention:** [How long is data kept, what gets purged]
- **GDPR/CCPA:** [Whether applicable and how compliance is implemented]

## Dependency Security

- Run `[audit command]` (e.g., `npm audit`, `pip-audit`) before adding new dependencies
- Review package authors and maintenance status before adding new dependencies
- Dependencies with known Critical or High CVEs are not permitted unless patched or mitigated

## HTTP Security Headers

All responses must include:
```
Content-Security-Policy: [your CSP]
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
```

## File Upload Security (if applicable)

- Validate MIME type server-side (do not trust `Content-Type` header alone)
- Enforce max file size: [N MB]
- Store uploads outside the web root or in a dedicated storage service
- Scan uploads for malware: [Yes/No — tool used]
- Allowed file types: [List allowed extensions]

## Incident Response

If a security issue is found in code review or production:
1. Do not attempt to fix silently — escalate immediately
2. Assess whether live data was exposed
3. Contact: [security contact / channel]
4. Document in: [issue tracker / postmortem system]

## Security Exceptions

Any deviation from this policy requires documented justification and approval from:
[Name/role of approver]
