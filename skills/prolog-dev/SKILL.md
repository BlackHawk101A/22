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
  ```
- **Run any other goal:**
  ```bash
  swipl -q -f code/<id>_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt
  swipl -q -f code/<id>_q2.pl -g "all_equations([4,2,5,3], Es), print(Es), nl" -t halt
  ```
- **Load check:** loading a solution file with no goal must print nothing and raise no warnings (singleton variables, discontiguous clauses).
- **Unit tests:** run from the repository root:
  ```bash
  swipl -q -g run_tests -t halt tests/test_q1.pl
  swipl -q -g run_tests -t halt tests/test_p2.pl
  ```
  Test files `consult` the solution with a path relative to `tests/`, e.g. `'../code/<id>_q1.pl'`.

## 4. Self-Review Checklist (apply before answering)
1. No `assert`/`retract`, no `b_setval`/`nb_setval`, no `:- initialization`, no `halt` in the solution file.
2. Only `lists`, `apply`, `yall`, `aggregate` are loaded.
3. Every predicate has a mode line and a declarative reading comment above it.
4. Atoms vs strings are right: quoted atoms such as `'Alex'`, `'c++'`, `'AI'`; P2 results are strings (`string/1` succeeds), with no spaces.
5. Arithmetic uses `is`/`=:=` only on bound values; division is guarded (divisor non-zero, exact result).
6. Predicates that must fail (e.g. lists of length 0 or 1) fail cleanly, without looping or throwing.
7. Nothing is printed except the output the spec asks for, in exactly the specified format.
8. Checked against every example in the spec, and `findall`/`sort` results compared with the expected lists.

## 5. Known AI Failure Modes in Prolog
- Using `=` or `==` where arithmetic comparison `=:=` is needed, or calling `is` on unbound variables.
- Writing `/` for exact division without checking the remainder, so `5/2` silently becomes a float.
- Returning atoms or code lists instead of SWI-Prolog strings, or adding spaces with `format`.
- Generate-and-test in the wrong order (testing clues on unbound variables), so negations like `\==` succeed too early.
- Unintended choicepoints or duplicate answers; forgetting `sort/2` to remove duplicates.
- Infinite recursion on left-recursive splits (allowing an empty side when splitting a list).
- Hard-coding the answer to a puzzle instead of deriving it from the clues.
- Adding `:- initialization(main).` or `halt.` at the end of the file out of habit.
- Mixing up the parenthesis rule: left operands need parentheses only for strictly lower precedence, right operands for lower *or equal*.
