---
name: stack-spring
description: Conventions and lessons for Java Spring backends. Use when working in Spring Boot, Spring MVC/REST, Spring Security, Spring Data JPA, Spring JDBC, Spring Batch, Actuator, or Maven/Gradle Java projects. In learn mode follow programming-foundations.
---

# Spring

Check the installed Spring Boot version, then look up its APIs with Context7.
Security configuration changed shape across major versions; never copy old
`WebSecurityConfigurerAdapter` examples.

## Learn mode: the mental model (teach in this order)

1. A request flows **controller -> service -> repository -> database**, and the
   response flows back. Each layer has one job.
2. The Spring **container** creates objects ("beans") and hands them to whoever
   asks through their constructor (**dependency injection**). You do not call
   `new` on services.
3. **Annotations** (`@RestController`, `@Service`, `@Entity`) are labels that
   tell Spring what a class is for. Spring Boot **auto-configures** sensible
   defaults from what is on the classpath.
4. A **DTO** is the shape of data crossing the API; an **entity** is the shape
   in the database. Keep them separate.
5. Exceptions are mapped to HTTP errors in one place.

Order for a beginner: hello endpoint -> DTO + validation -> service -> repository
-> error handler -> tests -> security.

## Rules (review and ship mode)

### Structure
- Controller thin, service holds business logic, repository only does data
  access. DTOs at the API edge; never return JPA entities from controllers.
- `@ConfigurationProperties` for config, validated with `@Validated`. Profiles for
  environments; no secrets in `application.yml`.
- Constructor injection only.

### Validation and errors
- Bean Validation on request DTOs (`@Valid`). One `@RestControllerAdvice` maps
  exceptions to a consistent error body (ProblemDetail). No stack traces or SQL in responses.

### Spring Security
- Declare a `SecurityFilterChain` bean; deny by default, open specific paths.
  Stateless APIs: disable sessions deliberately and say why CSRF is off.
- Authorize at the service/method level too (`@PreAuthorize`) for resource
  ownership, not only URL rules.
- Passwords via a delegating `PasswordEncoder`. No custom crypto or token formats.

### Spring Data JPA / JDBC
- Turn off open-in-view. Watch for N+1: fetch joins, entity graphs, or DTO
  projections; verify with the SQL log.
- Transactions at the service layer, as narrow as possible; `readOnly = true` for reads.
- JdbcTemplate/JdbcClient for set-based or reporting queries. Always parameterized.
- Schema changes via Flyway or Liquibase. Never `ddl-auto=update` outside local dev.

### Spring Batch
- Chunk size is a tuning decision: measure memory and commit cost.
- Idempotent writers so a restart cannot double-write. Explicit skip/retry policy
  per exception type.
- Deterministic job parameters. Know what the job repository tables store before
  changing step definitions.
- Test steps with `JobLauncherTestUtils` and a real database (Testcontainers).

### Actuator
- Expose only `health`, `info`, maybe `metrics`; protect the rest or use a separate
  management port. Never expose `env`, `heapdump`, or `beans` publicly.

## Common mistakes

- Returning an entity from a controller -> leaks columns, breaks on lazy fields.
- Field injection (`@Autowired` on a field) -> hides dependencies, hard to test.
- `@Transactional` on a method called from the same class -> the proxy is bypassed
  and no transaction starts.
- Reading a lazy relation after the transaction ended -> `LazyInitializationException`;
  fix with a fetch plan or DTO, not by widening the transaction.
- `catch (Exception e) {}` that swallows errors -> failures disappear silently.
- Trusting the client for ownership: `GET /jobs/42` without checking whose job 42 is.

## Why this matters

Layer boundaries keep code testable and changeable; authorization at the service
layer is what stops one user reading another's data (the most common real-world
web failure).

## Gates

`./mvnw -q verify` or `./gradlew check`. JUnit 5 + Mockito for unit tests,
Testcontainers for integration (see `stack-testing`).

## Capstone step (Life OS)

Build `Job` (company, title, status, appliedOn): entity, DTOs, repository,
service, `/api/jobs` CRUD with validation and a ProblemDetail error handler.
Done when: invalid input returns a clear 400, a missing id returns 404, and a
JUnit test per service method plus one Testcontainers repository test pass.

## Look up (Context7)

Spring Boot: "Web", "Externalized Configuration", "Testing"; Spring Data JPA:
"Query methods", "Projections"; Spring Security: "Authorization", "Method Security";
Spring Batch: "Chunk-oriented processing".
