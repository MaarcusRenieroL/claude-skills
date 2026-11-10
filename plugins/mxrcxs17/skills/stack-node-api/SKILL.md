---
name: stack-node-api
description: Conventions and lessons for Node.js and TypeScript backends. Use when working in Express, Hono, tRPC, Strapi, Payload CMS, or any Node API or server code. In learn mode follow programming-foundations.
---

# Node API

Check Context7 for the installed version's API (Hono, tRPC, Payload and Strapi
all differ a lot between majors).

## Learn mode: the mental model

1. A server **listens** on a port and runs a function (a **handler**) for each
   request: method + path in, status + JSON out.
2. **Middleware** are functions that run before handlers (logging, auth, parsing).
3. Layers match Spring: handler (thin) -> service (logic) -> data access. If the
   user knows Spring, map the ideas one to one.
4. Node runs your JavaScript on one thread; `async/await` lets it wait on I/O
   without blocking. Blocking the thread freezes every request.
5. Order for a beginner: hello route -> parse + validate body with zod -> service
   -> data -> error handler -> auth.

## Rules (review and ship mode)

### Any Node API
- Parse and validate every body, query, and param with zod at the edge. Handlers
  call services; services hold logic; handlers stay thin.
- One error shape. Map known errors to status codes centrally; log unknown ones;
  never return stack traces.
- Auth middleware verifies identity; the service layer checks ownership of the
  specific resource.
- CORS an explicit allowlist. Rate limit auth and write endpoints. Security
  headers (helmet or equivalent).
- Async errors must reach the error handler (Express 4 needs wrappers; confirm
  for the installed version).
- Graceful shutdown: stop accepting requests, drain, close DB pools.

### tRPC
- Every procedure has an input schema. Define `protectedProcedure` once with
  auth middleware. No business logic in routers; share types, not implementation.

### Hono
- Type the context variables; use the validator middleware with zod. Pick the
  runtime (Node, Bun, edge) up front because available APIs differ.

### Strapi / Payload
- They are CMSs with their own access-control model: configure roles/access
  explicitly; defaults are not guaranteed safe.
- Custom logic goes in supported extension points, not patched internals.
- Content-model changes are schema changes: treat them like migrations.

## Common mistakes

- Trusting `req.body` types without runtime validation (TypeScript types vanish at runtime).
- Forgetting `await`, so errors become unhandled promise rejections.
- Returning the raw error object to the client.
- Business logic inside the route handler, making it untestable.

## Why this matters

Validation at the edge and a single error shape are what keep an API predictable
for clients and safe against malformed or hostile input.

## Gates

Lint, `tsc --noEmit`, tests (see `stack-testing`), and a boot smoke test: start
the server and hit the health endpoint.

## Capstone step (Life OS)

Only if you add a Node service (for example an MCP server or AI proxy): a
`/health` route plus one validated POST route with a service and a test. Done
when: bad input returns 400 with the shared error shape.

## Look up (Context7)

Express: "Routing", "Error handling"; Hono: "Validation"; tRPC: "Procedures",
"Middleware"; zod: "Basic usage".
