# P1 Report

## P1.b: count for clues 1-8

`count_solutions([1,2,3,4,5,6,7,8], N)` gives **N = 3**.

This means the puzzle is under-determined: clues 1-8 do not identify a single
solution, so at least one more clue is needed.

The three solutions all share Ben = [development, javascript, web]. They differ as follows:

1. Alex = [design, java, AI],          Carla = [research, c++, data],  Dana = [testing, python, embedded]
2. Alex = [design, java, embedded],    Carla = [testing, python, AI],  Dana = [research, c++, data]
3. Alex = [testing, python, embedded], Carla = [design, java, AI],     Dana = [research, c++, data]

Solutions 1 and 3 contain the same set of (department, language, project)
triples with the names swapped between Alex, Carla and Dana. A clue that does
not mention names therefore cannot tell them apart: it keeps both or drops both.

## P1.c: repair

```
% CLUE 9: The friend who prefers the AI project works in the testing department.
```

This is true only in solution 2 and false in solutions 1 and 3 (in those, the
AI friend works in design). With it,
`count_solutions([1,2,3,4,5,6,7,8,9], N)` gives **N = 1**.

The kept solution is:

```
Alex = [design, java, embedded]
Ben = [development, javascript, web]
Carla = [testing, python, AI]
Dana = [research, c++, data]
```

Note that `main/0` uses all nine clues, so it prints this unique solution,
which is derived from the clues and not hard-coded.
