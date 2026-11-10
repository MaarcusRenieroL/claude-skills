---
name: stack-angular
description: Angular conventions and lessons. Use when working in Angular (components, templates, services, RxJS, signals, forms, routing, HttpClient, TestBed/Karma/Jasmine) or Angular Material. In learn mode follow programming-foundations.
---

# Angular

Do not state Angular version facts from memory. Check the installed version in
`package.json`, then look up current APIs with Context7. Angular changed a lot
(standalone components, signals, new template control flow), so tutorials may
show an older style: follow what the repo already uses.

## Learn mode: the mental model (teach in this order)

1. A **component** = a TypeScript class (logic) + a template (HTML) + styles.
2. **Template binding**: show a value `{{ x }}`, bind a property `[prop]="x"`,
   react to an event `(click)="doIt()"`.
3. **Services** hold logic and data shared by components; Angular hands them to
   you through **dependency injection** (you ask for one, you do not `new` it).
4. **Routing** maps URLs to components.
5. **HttpClient** talks to the backend; it returns an **Observable** (a stream of
   values over time). You must subscribe, or use the `async` pipe, or nothing happens.
6. **Forms** (reactive forms): the form is an object in code; the template binds to it.
7. **Signals / RxJS**: two ways to represent changing state. Learn one first (use
   what the repo uses), then the other.

Java comparison for the user: a component is like a view class, a service is
like a Spring `@Service`, DI is the same idea as Spring's constructor injection.

## Rules (review and ship mode)

- Follow the repo's existing style: standalone vs NgModules, signals vs RxJS.
  Never mix in a second style in one feature.
- Components stay thin: presentation and user events. Business logic and HTTP
  go in services.
- Never leak subscriptions: prefer the `async` pipe, `takeUntilDestroyed`, or
  signals; a manual `subscribe` needs a matching teardown.
- Types everywhere. No `any`; model API responses with interfaces that match the
  backend DTOs.
- Reactive forms for anything beyond one field; validate in the form AND on the
  server (client validation is UX only).
- `trackBy` / `track` in lists. Avoid heavy work in template expressions and getters.
- Never build HTML from user strings (`innerHTML`, bypassing sanitization). Angular
  escapes by default; do not turn that off.
- Auth tokens: do not put secrets in the bundle; use an HTTP interceptor for
  attaching credentials; route guards are UX, the server enforces access.
- Accessibility: semantic elements, labels tied to inputs, visible focus, keyboard use.

## Common mistakes

- Subscribing in a component and never unsubscribing -> memory leak and duplicate calls.
- Nested `subscribe` inside `subscribe` -> use RxJS operators (`switchMap`, etc.).
- Calling an HTTP method in a template or getter -> runs on every change detection.
- Mutating an object that a child component reads, then wondering why the view
  did not update -> create a new object/signal value.
- Using `any` to silence a type error instead of fixing the model.

## Why this matters

Leaked subscriptions and logic-heavy components are the top causes of slow,
untestable Angular apps; keeping logic in services is also what makes tests easy.

## Testing

TestBed with minimal declarations/imports; `HttpTestingController` (or the
current equivalent from Context7) instead of real HTTP; `jasmine.createSpyObj`
for collaborators; test behavior the user sees (rendered text, emitted events).

## Gates

Lint, `ng build` (or the repo's build), unit tests. Run via `gates.sh --full`.

## Capstone step (Life OS)

Build the job-list screen: a list component fed by a service that calls the
Spring API, with a reactive form to add a job. Done when: the list renders from
the API, the form validates required fields, and one component test and one
service test pass.

## Look up (Context7)

Angular: "Components", "Dependency injection", "HttpClient", "Signals",
"Reactive forms", "Testing"; RxJS: "Operators"; Angular Material: component docs.
