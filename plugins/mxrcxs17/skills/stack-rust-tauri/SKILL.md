---
name: stack-rust-tauri
description: Rust and Tauri conventions and lessons. Use when working in Rust code, Cargo projects, or Tauri desktop apps. In learn mode follow programming-foundations.
---

# Rust / Tauri

Check Context7 for the installed Tauri major version; v1 and v2 differ, notably
the permission/capability model.

## Learn mode: the mental model

1. **Ownership**: every value has one owner; when the owner goes out of scope the
   value is freed. No garbage collector, no manual free.
2. **Borrowing**: you may lend a value out by reference (`&T` read-only, `&mut T`
   exclusive). The compiler enforces: many readers OR one writer.
3. **Result and Option** replace exceptions and null: you must handle the error
   or the missing value. `?` passes an error up.
4. The compiler is the teacher: read its error messages fully; they usually say what to do.
5. **Tauri**: a Rust backend plus a web frontend in a webview. The frontend calls
   Rust through **commands**.
6. Compare to Java: `Option` ~ `Optional`, `Result` ~ checked exceptions made explicit.
   Start with Rust Book-style exercises (variables, structs, enums, `match`)
   before touching Tauri.

## Rules (review and ship mode)

### Rust
- Gates: `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test`.
- Errors: `thiserror` for typed library-style errors, `anyhow` at application
  edges. No `unwrap()` outside tests and truly impossible cases; use `?`.
- Prefer borrowing and iterators over cloning to appease the borrow checker. If
  you clone to compile, say why.
- Async: pick one runtime (usually tokio); do not block it with synchronous I/O;
  `spawn_blocking` for heavy work.

### Tauri
- The webview is untrusted. Every `#[tauri::command]` validates its arguments
  and returns typed errors.
- Grant the minimum permissions/capabilities. Do not expose shell, filesystem, or
  HTTP broadly to the frontend.
- Heavy and sensitive logic stays in Rust; the frontend renders and calls commands.
- Local-first apps that talk to local services (for example Ollama on localhost):
  set timeouts, handle the service being down, never send user data to remote
  hosts without opt-in.

## Common mistakes

- Fighting the borrow checker with `.clone()` everywhere instead of rethinking ownership.
- `unwrap()` on user-controlled data -> a crash instead of an error.
- Holding a lock across an `.await`.
- Granting a Tauri window access to the whole filesystem "for convenience".

## Why this matters

Rust moves whole classes of bugs (memory, data races) to compile time, but only
if you let the compiler's rules shape your design instead of working around them.

## Capstone step (Life OS)

Optional, later: a small Tauri window that lists jobs via a Rust command reading
a local file. Done when: the command validates input, returns a typed error for a
missing file, and clippy is clean.

## Look up (Context7 / docs by name)

The Rust Book: "Ownership", "Error Handling"; Tauri: "Commands", "Capabilities";
tokio: "Tutorial".
