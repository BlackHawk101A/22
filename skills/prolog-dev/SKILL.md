---
name: prolog-dev
description: Guidelines, conventions, testing commands, and review checklists for writing pure SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 and P2).
---

# Prolog Development Skill (CS F301 Assignment 2)

## 1. Environment & Constraints
- **Language & Version:** SWI-Prolog 9.x.
- **Allowed Libraries:** `lists`, `apply`, `yall`, `aggregate` only.
- **Forbidden Features:**
  - No `assert/1`, `retract/1`, or dynamic database predicates.
  - No global variables (`b_setval/2`, `nb_setval/2`).
  - No `:- initialization(...)` directives.
  - No explicit calls to `halt/0` inside solution files.
  - Do not print anything to stdout unless explicitly required by the predicate specification.
  - For P2: Do not build strings and parse them back into terms to evaluate expressions.
- **Decomposition Rule:** Every prompt and response must cover exactly one unit of work (one predicate, one test file, or one review).

## 2. Coding Conventions
- **Naming:** Use `snake_case` for all predicate and helper names. Use meaningful `CamelCase` variable names (e.g., `ExprTree`, `LeftVal`, `RestNums`) and `_` for singleton/unused variables.
- **Declarative Reading:** Every non-trivial predicate must have a concise comment block directly above it stating:
  - Its mode/signature (e.g., `% expr(+Nums, -Tree, -Value)`).
  - Its declarative reading (what relation holds between the arguments when the predicate succeeds).
- **Purity & Determinism:** Prefer pure relational predicates and clean pattern matching. Use cuts (`!`) sparingly and only when green or strictly necessary to prevent unintended backtracking.
- **Data Types:** Pay strict attention to atoms vs. SWI-Prolog strings (double-quoted `"..."`). For P2, final equations must be SWI-Prolog strings with no spaces.

## 3. Running & Testing
Run solution files from the command line without modifying them:
- **Run `main/0` (P1):**
  ```bash
  swipl -q -f code/<id>_q1.pl -g main -t halt