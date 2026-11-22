:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(yall)).
:- use_module(library(aggregate)).

% ---------- candidate generation ----------
candidate([p('Alex',D1,L1,P1),
           p('Ben', D2,L2,P2),
           p('Carla',D3,L3,P3),
           p('Dana',D4,L4,P4)]) :-
    permutation([research,development,design,testing], [D1,D2,D3,D4]),
    permutation([python,java,'c++',javascript],         [L1,L2,L3,L4]),
    permutation(['AI',web,embedded,data],               [P1,P2,P3,P4]).

% ---------- clues ----------
% 1. The AI friend is not in research and is not Dana.
clue(1, S) :- member(p(N,D,_,'AI'), S), D \== research, N \== 'Dana'.
% 2. Alex is not in development and does not like C++.
clue(2, S) :- member(p('Alex',D,L,_), S), D \== development, L \== 'c++'.
% 3. The testing friend likes Python.
clue(3, S) :- member(p(_,testing,L,_), S), L == python.
% 4. Ben prefers web and is not in testing.
clue(4, S) :- member(p('Ben',D,_,P), S), P == web, D \== testing.
% 5. The Java friend works in design.
clue(5, S) :- member(p(_,D,java,_), S), D == design.
% 6. Carla does not prefer embedded and is not in development.
clue(6, S) :- member(p('Carla',D,_,P), S), P \== embedded, D \== development.
% 7. Dana does not like Java and is in research or testing.
clue(7, S) :- member(p('Dana',D,L,_), S), L \== java, memberchk(D, [research,testing]).
% 8. The data friend is in research and does not like JavaScript.
clue(8, S) :- member(p(_,D,L,data), S), D == research, L \== javascript.
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, S) :- member(p(_,D,_,'AI'), S), D == testing.

% ---------- solving / counting ----------
solution(Active, S) :-
    candidate(S),
    forall(member(N, Active), clue(N, S)).

% ---------- main ----------
main :-
    once(solution([1,2,3,4,5,6,7,8,9], S)),
    forall(member(p(Name,D,L,P), S),
           format("~w = [~w, ~w, ~w]~n", [Name,D,L,P])).
