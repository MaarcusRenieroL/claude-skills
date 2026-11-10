---
name: security-checklist
description: Security lessons and review checklist for web and API code. Use when reviewing or writing authentication, authorization, input handling, file uploads, secrets, dependencies, or anything exposed to the internet. In learn mode follow programming-foundations.
---

# Security

## Learn mode: the mental model

1. **Never trust input.** Anything from a browser, request, file, or another
   system could be malicious or just wrong.
2. **Authentication** = who are you. **Authorization** = what may you do. They
   are different checks; both happen on the server.
3. **Least privilege**: give each user, token, and service only what it needs.
4. **Defense in depth**: several small barriers, not one big one.
5. Ask for every feature: "what would a hostile user do here?" Have the user
   answer before you reveal the attack.

## Checklist (review and ship mode)

Work through what applies to the diff. Report findings as `path:line`, the
attack, and the fix.

### Access control (most common real-world failure)
- Every new endpoint, action, and job has authentication AND an authorization
  rule. Can user A read or change user B's data by changing an ID (IDOR)? Are
  admin-only paths checked server-side?
- Deny by default. Client-side checks do not count.

### Authentication and sessions
- No custom crypto, token formats, or password hashing. Passwords hashed with
  bcrypt/argon2 via the framework/library.
- Tokens expire; logout and rotation work; cookies are HttpOnly, Secure, SameSite
  as appropriate. Rate limit login and reset flows.

### Input and output
- Validate type, length, format at the boundary (zod / Bean Validation).
  Parameterized queries only; no string-built SQL or shell commands.
- Output encoding for HTML; no `dangerouslySetInnerHTML`, `v-html`, or Angular
  sanitizer bypasses with untrusted data.
- File uploads: check size and type by content, store outside the web root,
  random names.
- Outbound requests to user-supplied URLs: SSRF. Allowlist hosts, block internal ranges.
- CSRF protection for cookie-authenticated state-changing requests.

### Secrets and data
- No secrets in code, logs, error messages, client bundles, or Docker layers.
  `.env*` ignored by git.
- Logs contain no passwords, tokens, or personal data. Errors do not leak internals.

### Dependencies and config
- New dependencies: maintained? needed? known advisories (`npm audit`, OWASP
  dependency-check)? Pin versions.
- CORS is an explicit allowlist; debug endpoints and verbose errors are off in
  production; security headers set.

## Common mistakes (show wrong vs right)

- Wrong: `"SELECT * FROM jobs WHERE id=" + id`. Right: a parameterized query.
- Wrong: hiding the Delete button for non-admins. Right: the server rejects the request.
- Wrong: committing `.env` "just for now". Right: rotate the secret and ignore the file.
- Wrong: `GET /jobs/42` returns it because the user is logged in. Right: it
  returns it only if job 42 belongs to that user.

## Why this matters

Broken access control is consistently the top category in OWASP's Top 10, and
it is a logic error, not a tooling gap: only careful reasoning finds it.

## Say what you did not check

Finish every review with a line listing the areas you could not verify.

## Capstone step (Life OS)

Add two users and write a test proving user A gets 404/403 for user B's job. Done
when: the test fails before you add the ownership check and passes after.

## Look up (Context7 / docs by name)

OWASP Top 10 and Cheat Sheet Series ("Authorization", "SQL Injection Prevention");
Spring Security: "Authorization"; Angular: "Security".
