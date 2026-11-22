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
  - Arithmetic & comparison: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`.
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
  ```
- **Grader simulation:** copy the solution file, append the example calls from the spec (e.g. `(print-inorder '(4 (2 () ()) ()))`) and run it with `racket`. Compare the output line by line with the spec.
- **Unit tests:** `raco test tests/test_s1.rkt` (rackunit; tests may use any library, only the solution file is restricted).
- **Forbidden-name scan:** `grep -nE "set!|append|length|reverse|\(map |filter|member|memq|list-ref|list-tail|vector|hash|string|\(for|\(do " code/<id>_q3.rkt` must only match `my-` helpers or comments.

## 4. Self-Review Checklist (apply before answering)
1. Line 1 is `#lang racket/base`; the file contains only `define`s (no top-level calls, no printing at load time).
2. Only the allowed built-ins are used; any needed helper is written by hand with a `my-` prefix.
3. Every function has a signature comment and a recursive reading (base case, recursive step, tail-recursive or not).
4. The base case for the empty tree / empty list `()` is handled first.
5. Every printing function ends with exactly one `(newline)` per line of output.
6. All state goes through arguments (accumulators), never through mutation.
7. Checked by hand against at least one spec example and the empty case.

## 5. Known AI Failure Modes in Scheme
- Reaching for `append`, `reverse`, `length` or `map` out of habit instead of writing a helper or using an accumulator.
- Using `set!` or a mutable accumulator to "collect" values.
- Building a list in the wrong order with an accumulator and then calling `reverse` to fix it.
- Off-by-one height (treating `()` as height 1 or a leaf as height 0).
- Counting the empty tree `()` as a leaf, or forgetting that a leaf needs *both* children empty.
- Forgetting the final `(newline)`, or printing with `write`/`printf` instead of `display`.
- Leaving test calls at the top level of the solution file.
- Confusing `cadr`/`caddr` (left vs right subtree of `(value left right)`).
