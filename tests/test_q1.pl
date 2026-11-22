% Run from the root folder with:
%   swipl -q -g run_tests -t halt tests/test_q1.pl
:- consult('../code/22_q1.pl').

all_clues([1,2,3,4,5,6,7,8,9]).

% The unique solution (all 9 clues)
answer([p('Alex',design,java,embedded),
        p('Ben',development,javascript,web),
        p('Carla',testing,python,'AI'),
        p('Dana',research,'c++',data)]).

% The other two solutions of clues 1-8
other(1, [p('Alex',design,java,'AI'),
          p('Ben',development,javascript,web),
          p('Carla',research,'c++',data),
          p('Dana',testing,python,embedded)]).
other(2, [p('Alex',testing,python,embedded),
          p('Ben',development,javascript,web),
          p('Carla',design,java,'AI'),
          p('Dana',research,'c++',data)]).

% The format example from the assignment, completed to a full (wrong) candidate
example([p('Alex',design,java,web),
         p('Ben',testing,python,data),
         p('Carla',research,'c++','AI'),
         p('Dana',development,javascript,embedded)]).

% ---- test cases: test(Name, Goal) ----
test(count_1_to_8,          (count_solutions([1,2,3,4,5,6,7,8], N), N =:= 3)).
test(count_1_to_9,          (count_solutions([1,2,3,4,5,6,7,8,9], N), N =:= 1)).
test(count_no_clues,        (count_solutions([], N), N =:= 13824)).   % 24^3
test(count_clue_9_alone,    (count_solutions([9], N), N > 0)).
test(count_ignores_others,  (count_solutions([3], A), count_solutions([3,3], B), A =:= B)).
test(count_order_irrelevant,(count_solutions([9,8,7,6,5,4,3,2,1], N), N =:= 1)).
test(answer_satisfies_all,  (answer(S), all_clues(L), forall(member(N,L), clue(N,S)))).
test(other_satisfy_1_to_8,  (forall(other(_,S),
                               forall(between(1,8,N), clue(N,S))))).
test(clue9_false_on_others, (forall(other(_,S), \+ clue(9,S)))).
test(example_fails_clue4,   (example(S), \+ clue(4,S))).
test(example_fails_clue7,   (example(S), \+ clue(7,S))).
test(example_fails_clue8,   (example(S), \+ clue(8,S))).
test(example_passes_3_5,    (example(S), clue(3,S), clue(5,S))).
test(example_not_a_solution,(example(S), \+ (all_clues(L), forall(member(N,L), clue(N,S))))).
test(clue9_has_no_names,    (clause(clue(9,_), Body),
                             \+ ( sub_term(X, Body), atom(X),
                                  memberchk(X, ['Alex','Ben','Carla','Dana']) ))).
test(main_output,           (with_output_to(string(Out), main),
                             Out == "Alex = [design, java, embedded]\nBen = [development, javascript, web]\nCarla = [testing, python, AI]\nDana = [research, c++, data]\n")).
test(main_leaves_no_choice, (call_cleanup(with_output_to(string(_), main), Det = true),
                             Det == true)).

run_tests :-
    findall(Name-Goal, test(Name, Goal), Tests),
    length(Tests, Total),
    foldl([Name-Goal, P0, P]>>( catch(Goal, E, (format("ERROR ~w: ~q~n",[Name,E]), fail)) ->
                                    P is P0+1
                                ;   format("FAIL  ~w~n", [Name]), P = P0 ),
          Tests, 0, Passed),
    format("~w/~w tests passed~n", [Passed, Total]),
    ( Passed =:= Total -> true ; halt(1) ).
