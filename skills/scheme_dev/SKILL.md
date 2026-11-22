---
name: scheme-dev
description: Guidelines, allowed built-ins, conventions, testing commands, and review checklists for writing pure Scheme (#lang racket/base) code for CS F301 Assignment 2 (S1 and S2).
---

# Scheme Development Skill (CS F301 Assignment 2)

## 1. Environment & Constraints
- **Language & Version:** Racket 8.x using `#lang racket/base` at line 1.
- **Strictly Allowed Built-ins:**
  - Special forms: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
  - List primitives: `cons`, `car`, `cdr`, `list`, and `c...r` compositions up to 4 levels (`cadr`, `cddr`, `caddr`, `cadddr`, `cddddr`, etc.), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
  - Arithmetic & comparison: `+`, `-`, `*`, `/`, `<`, `>`, `<=`, `>=`, `=`, `max`.
  - I/O: `display`, `newline` (and `read` for S2 only).
- **Forbidden Features:**
  - No `set!` or any mutating primitives.
  - No vectors, hash tables, or strings.
  - No loops (`do`, `for`, `for/list`, etc.).
  - No standard list helpers: `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`. Write custom helpers (e.g., `my-reverse`, `my-append`, `my-length`, `my-map`).
  - No top-level function calls or top-level printing when the file is loaded (only definitions).
- **Decomposition Rule:** Every prompt and response must cover exactly one unit of work (one function, one test file, or one review).

## 2. Coding Conventions
- **Naming:** Use `kebab-case` for all function and variable names (e.g., `print-inorder`, `my-reverse`, `left-sub`). Use `?` suffix for predicates (e.g., `leaf?`, `len-ok?`).
- **Recursive Reading:** Every function must have a concise comment block directly above it stating:
  - Its signature/contract (e.g., `; inorder-acc : Tree List -> List`).
  - Its recursive reading (base case + recursive step, and whether it is tail-recursive).
- **State & Recursion:** Pass all state explicitly through function arguments. Prefer tail recursion with accumulators where natural (especially for large inputs like 10,000-element lists or depth-100 nesting in S2).

## 3. Running & Testing
Since solution files must contain only definitions, run tests via a separate test file (or by piping/appending test calls):
- **Syntax/load check (must print nothing):**
  ```bash
  racket code/<id>_q3.rkt