---
name: security-review
description: Analyze code for security vulnerabilities, data exposure, authentication issues, injection risks, and compliance with security best practices. Use when the user asks to audit security, find vulnerabilities, or review code for safety.
---

# Security Review

Analyze the code for security implications. Focus on actual vulnerabilities, not hypothetical threats.

## Instructions

1. **Understand the context** — what does the code do? What data does it handle? Who are the users?

2. **Check for common vulnerability classes:**

   - **Injection** — SQL, command, XSS, template injection. Are inputs sanitized? Are prepared statements used?
   - **Authentication & Authorization** — are endpoints protected? Is there privilege escalation? Session handling issues?
   - **Data Exposure** — are secrets, PII, or internal details leaked in logs, errors, or responses?
   - **Input Validation** — are user inputs validated on the server side? Type checking, bounds checking, allowlists?
   - **Cryptography** — are weak algorithms used? Hardcoded keys? Missing TLS? Improper certificate validation?
   - **File Operations** — path traversal? Unsafe symlinks? Temporary file races?
   - **Dependencies** — are there known vulnerable dependencies? Outdated packages?
   - **Race Conditions** — TOCTOU, async safety, shared mutable state
   - **Configuration** — debug mode enabled? Default credentials? Permissive CORS? Overly broad permissions?

3. **Format your review:**
   - **Summary** — overall risk level and key findings
   - **Findings** — list each finding with severity: `🔴 Critical`, `🟡 High`, `🟠 Medium`, `🔵 Low`, `⚪ Informational`
   - **Exploitability** — how hard is it to exploit? (Remote? Authenticated? Requires user interaction?)
   - **Remediation** — concrete steps to fix each issue

4. **Be realistic.** Focus on practical, exploitable issues. Avoid noise. If something is fine, say so.

## Examples

### Finding format

```markdown
🔴 Critical: SQL Injection in `getUser()` (remote, unauthenticated)
User input on line 23 is concatenated directly into a SQL query.
An attacker can inject `' OR 1=1--` to bypass authentication.
Fix: use parameterized queries (prepared statements).
```

```markdown
🟡 High: Hardcoded API key in `config.ts` line 12
The AWS secret key is stored in plaintext in the repository.
Fix: use environment variables or a secrets manager.
```

```markdown
🔵 Low: Missing rate limiting on `/api/login` (remote, unauthenticated)
No rate limiting allows brute-force password attacks.
Fix: add rate limiting (e.g., 5 attempts per minute per IP).
```

## References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)