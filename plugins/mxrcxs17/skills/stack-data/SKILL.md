---
name: stack-data
description: Database conventions and lessons. Use when designing schemas, writing queries or migrations, or working with PostgreSQL, MySQL, SQL Server, MongoDB, Redis, Prisma, Drizzle, or JPA mappings. In learn mode follow programming-foundations.
---

# Data

## Learn mode: the mental model (teach in this order)

1. A relational database is **tables** (rows and columns). A **primary key**
   identifies a row; a **foreign key** points to a row in another table.
2. SQL has four everyday verbs: `SELECT`, `INSERT`, `UPDATE`, `DELETE`. Start by
   typing them by hand in a SQL console before using an ORM.
3. An **index** is like a book's index: faster lookups, slower writes.
4. A **transaction** makes several writes succeed or fail together.
5. A **migration** is a versioned script that changes the schema; history is
   never rewritten.
6. An **ORM** (JPA/Prisma/Drizzle) maps rows to objects; it hides SQL, so learn
   to read the SQL it generates.

## Rules (review and ship mode)

### Migrations (all stacks)
- Use the repo's tool (Flyway, Liquibase, Prisma, Drizzle). Generate a new
  migration; never edit one that has been applied anywhere.
- Prefer expand-then-contract for risky changes: add the new column, backfill,
  switch the code, drop the old column in a later release.
- Always state whether a migration is destructive or locks a large table.

### Relational
- Index columns you filter, join, and sort on; verify with `EXPLAIN`.
- Constraints (NOT NULL, FK, UNIQUE, CHECK) belong in the database, not only app code.
- Parameterized queries only. Short transactions around multi-step writes.
- Money in integer minor units or DECIMAL, never floats. Timestamps in UTC.
- Keyset pagination over deep OFFSET for large tables.
- Dialects differ (quoting, upsert syntax, `LIMIT` vs `TOP`, JSON); do not assume portability.

### Prisma / Drizzle / JPA
- The schema/entity definition is the source of truth. Watch for N+1. Use the
  ORM's transaction API. Raw SQL escape hatches stay parameterized.
- Serverless: reuse one client and mind connection limits (pooler).

### MongoDB
- Model around access patterns: embed what is read together, reference what
  grows unbounded. Add indexes deliberately; validate documents.

### Redis
- Every key has a TTL unless it must live forever. Namespace keys
  (`app:entity:id`). Not the source of truth for data you cannot rebuild.
- Decide the cache invalidation rule before adding the cache.

## Common mistakes

- `SELECT *` and loading whole tables to filter in code.
- A query inside a loop (N+1) instead of one join or a batch.
- Using `float` for money -> rounding errors.
- Relying on app code for uniqueness with no UNIQUE constraint -> duplicates under concurrency.
- Editing an old migration "just this once".

## Why this matters

Data outlives code. A wrong schema or a lost migration is expensive to fix and
the damage is usually silent until production.

## Testing data code

Use a real database in tests (Testcontainers or a disposable local one), not an
in-memory fake with different behavior.

## Capstone step (Life OS)

Write the `jobs` table by hand in SQL (PK, NOT NULL company, CHECK on status,
index on status), then recreate it as a Flyway migration. Done when: you can
explain each constraint and `EXPLAIN` shows your index used for a status filter.

## Look up (Context7)

PostgreSQL: "CREATE TABLE", "Indexes", "EXPLAIN"; Flyway: "Migrations";
Spring Data JPA: "Entities"; Prisma/Drizzle: "Schema".
