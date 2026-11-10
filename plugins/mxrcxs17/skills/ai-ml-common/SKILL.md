---
name: ai-ml-common
description: Common practices and lessons for AI and ML work. Use when building LLM features, agents, RAG, prompts, evals, embeddings, local models (Ollama), or training and evaluating ML models. In learn mode follow programming-foundations.
---

# AI / ML

## Learn mode: the mental model (teach in this order)

1. An **LLM** predicts the next piece of text from the text so far. It does not
   "look things up"; it can state wrong things confidently.
2. A **prompt** is the input. Small wording changes change outputs, so measure
   with an **eval**: a fixed set of inputs with expected properties.
3. **Embeddings** turn text into numbers so similar meanings are close together.
   **RAG** = retrieve relevant chunks first, then give them to the model.
4. **Tool use / agents**: the model asks your code to call functions. Your code
   decides whether to allow it.
5. **Classical ML**: learn patterns from labeled data. Split the data before
   anything else, and always compare against a simple baseline.
6. Order for a beginner: call a model from code -> structured output + validation
   -> an eval -> embeddings + retrieval -> a tiny agent.

## Rules (review and ship mode)

### LLM-powered features
- Write the eval before tuning the prompt: 20-50 representative inputs with
  expected properties, runnable in one command.
- Request structured output and validate with a schema (zod / Pydantic / Bean
  Validation). Bounded retry, then a clear failure.
- Log prompt version, model, latency, and token counts per call.
- Prompts live in versioned files, not scattered string literals.
- Low or zero temperature for tests; mock the model in unit tests and keep a
  small live-model suite separate.

### Agents and tool use
- Everything a tool returns (web pages, files, emails) is untrusted data, never
  instructions (prompt injection).
- Least privilege per tool; confirm before irreversible actions; cap loop
  iterations and spend.

### RAG
- Measure retrieval quality separately from generation: check recall of the right
  chunks first.
- Chunk by meaning (headings, paragraphs) with some overlap; store source metadata
  for citations. Re-embed when the embedding model changes.

### Local-first (Ollama etc.)
- Handle the model not being pulled, the server down, and slow first tokens.
  Stream responses. Keep user data local unless explicitly shared.

### Classical ML
- Split before any preprocessing; fit scalers only on training data (no leakage).
  Start with a baseline. Metrics must fit the problem (not accuracy on imbalanced
  classes). Fix seeds and record versions.

## Common mistakes

- Judging a prompt by one or two good examples instead of an eval set.
- Parsing model output with string tricks instead of schema validation.
- Putting user or web text into a prompt with tool access and no guardrails.
- Normalizing the whole dataset, then splitting (leakage inflates scores).
- Reporting accuracy on a 95/5 class split.

## Why this matters

Model behavior is probabilistic. Without evals and validation you cannot tell
improvement from luck, and without guardrails untrusted text can take control of
your agent.

## Capstone step (Life OS)

Add a "summarize this job posting into title/company/skills" feature that returns
JSON validated by a schema, with a 20-item eval file. Done when: one command
prints a pass rate and invalid model output fails cleanly.

## Look up (Context7 / docs by name)

Provider SDK docs (structured output, tool use); Ollama: "API"; scikit-learn:
"Cross-validation", "Pipelines".
