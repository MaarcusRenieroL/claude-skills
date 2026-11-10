---
name: stack-web-ts
description: Conventions and lessons for TypeScript web apps with React and Next.js. Use when working in Next.js, React, Tailwind, shadcn/ui, or wiring auth (Auth.js/NextAuth, Better Auth, Clerk, Kinde), zod, or tRPC clients. Angular lives in stack-angular. In learn mode follow programming-foundations.
---

# Web / TypeScript (React, Next.js)

Check Context7 for current APIs and the installed versions. Do not write Next.js,
auth-library, or Tailwind syntax from memory.

## Learn mode: the mental model (teach in this order)

1. **TypeScript** = JavaScript plus types. Types are compile-time checks that
   catch mistakes before the code runs.
2. A **React component** is a function that takes props and returns UI. State
   (`useState`) is data that, when changed, re-renders the component.
3. **Server vs client**: in the Next.js App Router, components run on the server
   by default; `"use client"` marks the ones that need the browser.
4. **Data flow**: fetch on the server, pass props down, send changes back through
   a Server Action or an API route.
5. **Validation**: one zod schema describes valid data; use it on both sides.

Compare to Java for the user: `interface` ~ shape of an object, `Promise` ~ a
result that arrives later, `async/await` is how you wait for it.

## Rules (review and ship mode)

### Next.js (App Router)
- Server Components by default. `"use client"` only for state, effects, or
  browser APIs, pushed down to the smallest leaf.
- Fetch on the server. Do not call your own API routes from Server Components.
- Treat every Server Action and route handler as a public endpoint: authenticate,
  authorize, validate input with zod inside it.
- Validate env vars at startup with a zod schema. Never put secrets in `NEXT_PUBLIC_*`.
- Learn the caching behavior of the installed version before touching data fetching.

### Auth (Auth.js / Better Auth / Clerk / Kinde)
- One auth library per repo; find which and stay on it.
- Check sessions on the server near the data access. Middleware and client checks
  are UX, not security.
- Authorize by resource ownership, not just "is logged in". Every query returning
  user data filters by the current user or org.

### Forms, state, validation
- One zod schema is the source of truth; infer types with `z.infer`.
- Server state (React Query / tRPC hooks) is not client state; do not copy it into `useState`.

### Styling and UI
- Tailwind utilities with design tokens (CSS variables); no scattered arbitrary values.
- shadcn/ui: add via its CLI so components land in the repo, then edit them there.
- Accessibility: semantic elements, labels, visible focus, keyboard operation,
  contrast, reduced motion.

## Common mistakes

- Marking a whole page `"use client"` -> loses server rendering; push it to a leaf.
- `useEffect` to fetch data that could be fetched on the server.
- Copying props into state, then the UI goes stale.
- Missing `key` or using the array index as key in reorderable lists.
- Checking "logged in" in the UI but not in the Server Action.

## Why this matters

The client is untrusted: anyone can call your endpoints directly, so the server
must enforce every rule the UI suggests.

## Gates

Lint, `tsc --noEmit`, unit tests, then a build before merge (`gates.sh --full`).

## Capstone step (Life OS)

Only if the Life OS UI is React instead of Angular: a jobs page that renders a
server-fetched list and a form validated by a shared zod schema. Done when: an
invalid submit shows field errors and a valid one appears in the list.

## Look up (Context7)

React: "useState", "Components and props"; Next.js: "Server and Client Components",
"Server Actions"; zod: "Basic usage"; Tailwind: "Utility-first".
