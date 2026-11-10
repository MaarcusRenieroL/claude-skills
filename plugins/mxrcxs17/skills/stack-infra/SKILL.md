---
name: stack-infra
description: Infrastructure conventions and lessons. Use when working on Dockerfiles, docker-compose, nginx config, GitHub Actions workflows, or AWS resources. In learn mode follow programming-foundations.
---

# Infra

## Learn mode: the mental model

1. **Image vs container**: an image is a frozen recipe-result (your app plus its
   runtime); a container is a running copy of it.
2. **Compose** runs several containers together (app + database) from one file.
3. **CI** (GitHub Actions) is a robot that runs your checks on every push or pull request.
4. **Reverse proxy** (nginx) sits in front of your app, handling TLS and routing.
5. **Cloud (AWS)** is rented infrastructure; a mistake can cost money, so budget
   alarms come first.
6. Order for a beginner: run the app in a Dockerfile -> add a database with
   compose -> add a CI workflow -> only then cloud.

## Rules (review and ship mode)

### GitHub Actions (budget: about 2,000 minutes a month)
- Linux runners cost 1x; Windows and macOS are billed at higher multipliers.
  Default to `ubuntu-latest`.
- Add `concurrency` with `cancel-in-progress: true`, `paths` filters, dependency caching.
- Expensive jobs (E2E, builds, matrix) only on pull requests to main or on demand.
- Do the real checking locally with `gates.sh`; CI is the backstop.
- Pin third-party actions to a commit SHA. Least-privilege `permissions:` on every
  workflow. Never echo secrets.

### Docker
- Multi-stage builds, slim or distroless base, pinned tags. Non-root user.
  `.dockerignore` excludes `.git`, `node_modules`, `.env*`.
- One process per container; define a health check. No secrets in layers or build args.

### nginx
- Explicit `proxy_set_header` for host and forwarded headers; TLS only with HTTP
  redirect; security headers; sane timeouts and body-size limits. Run `nginx -t`
  before reload.

### AWS
- Least-privilege IAM; no long-lived access keys in code (use roles). Private by
  default for S3 and databases.
- Budget alarm before creating anything that bills. Tag resources. Prefer
  infrastructure as code over console clicks.

## Common mistakes

- `FROM node:latest` / unpinned tags -> builds change under you.
- Running as root in the container.
- Copying `.env` into the image.
- A CI workflow that runs the full matrix on every push and burns the minutes.
- Opening an S3 bucket or database to the public "to test".

## Why this matters

Infra mistakes are either security holes (exposed secrets, open buckets) or
surprise bills; both are avoidable with the defaults above.

## Capstone step (Life OS)

Write a Dockerfile for the Spring API and a compose file with PostgreSQL. Done
when: `docker compose up` brings up both, the API passes its health check, and
no secret appears in any file you committed.

## Look up (Context7 / docs by name)

Docker: "Multi-stage builds", "Compose"; GitHub Actions: "Workflow syntax",
"Security hardening"; nginx: "Reverse proxy".
