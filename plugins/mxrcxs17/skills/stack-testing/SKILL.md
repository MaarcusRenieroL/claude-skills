---
name: stack-testing
description: How to write good tests across this stack. Use when adding or fixing tests with JUnit, Mockito, Testcontainers, Jest, Vitest, Playwright, Cypress, Karma, or Jasmine, or when a repo has little or no coverage. In learn mode follow programming-foundations.
---

# Testing

## Learn mode: the mental model

1. A test is a small program that calls your code and checks the result. If the
   check fails, the test fails.
2. Shape of a test: **Arrange** (set up inputs), **Act** (call the code),
   **Assert** (compare to an expected literal value).
3. Red -> Green -> Refactor: write a failing test, make it pass with the least
   code, then clean up. In learn mode the user writes the test first; you review it.
4. Unit test = one piece in isolation. Integration test = pieces plus a real
   database. End-to-end = a real browser clicking through.

## Principles (review and ship mode)

- Test behavior through the public interface; assert literal expected values. If
  a test would still pass with the implementation deleted, rewrite it.
- No tests that only verify mocks were called, unless the call is the behavior
  (e.g. an outbound email).
- Fix bugs test-first: write the failing test that reproduces it, then fix.
- Flaky tests are bugs. Never fix them with sleeps; wait on a condition.

## Untested code

Write characterization tests that pin current behavior before changing anything.
Start with auth, money, and data writes. Record suspicious behavior separately
rather than blessing it.

## By tool

- **JUnit 5 + Mockito**: mock collaborators you own the contract of, not the
  thing under test. `@ParameterizedTest` for input tables.
- **Testcontainers**: real Postgres/MySQL/Redis in integration tests; reuse
  containers across a class. Needs Docker running.
- **Jest / Vitest**: co-locate unit tests; use fake timers deliberately and
  reset them; mock the network boundary, not internal modules.
- **Playwright**: preferred for new E2E. Role/label locators, auto-waiting, isolated
  state per test. E2E only for critical journeys.
- **Cypress**: if the repo already uses it, stay; do not run both.
- **Karma + Jasmine (Angular)**: TestBed with minimal declarations; spies via
  `jasmine.createSpyObj`; no real HTTP.

## Common mistakes

- Asserting `result != null` or "no exception" instead of the actual value.
- One giant test checking ten things; when it fails you cannot tell why.
- Tests sharing state, so order matters.
- Mocking the thing under test.
- Copying the production formula into the test's expected value.

## Why this matters

Tests are what let you change code without fear, and the only objective proof
that something works. A suite that cannot fail is worse than none.

## CI minutes are limited

Run tests locally via `gates.sh` before pushing. Keep the unit suite fast; E2E on
demand or on main only.

## Capstone step (Life OS)

Write the failing JUnit test for "adding a job with an empty company is rejected"
BEFORE writing the validation. Done when: you saw it fail, then pass, and can
explain why it failed first.

## Look up (Context7)

JUnit 5: "Parameterized tests"; Mockito: "Stubbing"; Testcontainers: "PostgreSQL
module"; Vitest/Jest: "Mocking"; Playwright: "Locators"; Angular: "Testing".
