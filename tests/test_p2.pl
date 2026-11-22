:- consult('../code/22_q2.pl').
:- use_module(library(plunit)).

:- begin_tests(p2_equations).

% --- split_list/3 ---

test(split_list_four_elements) :-
    findall(L-R, split_list([4,2,5,3], L, R), Splits),
    Splits == [[4]-[2,5,3], [4,2]-[5,3], [4,2,5]-[3]].

test(split_list_empty_fails, [fail]) :-
    split_list([], _, _).

test(split_list_single_fails, [fail]) :-
    split_list([7], _, _).

% --- build_expr/3 ---

test(build_expr_exact_division) :-
    build_expr([6,2], op(/, num(6), num(2)), 3).

test(build_expr_non_exact_division_fails, [fail]) :-
    build_expr([5,2], op(/, num(5), num(2)), _).

test(build_expr_div_by_zero_fails, [fail]) :-
    build_expr([5,0], op(/, num(5), num(0)), _).

test(build_expr_negative_intermediate) :-
    build_expr([1,3], op(-, num(1), num(3)), -2).

% --- expr_to_string/2 ---

test(expr_to_string_minimal_parens) :-
    expr_to_string(op(*, op(+, num(4), num(2)), num(3)), S1),
    S1 == "(4+2)*3",
    string(S1),
    expr_to_string(op(/, num(8), op(*, num(4), num(2))), S2),
    S2 == "8/(4*2)",
    string(S2),
    expr_to_string(op(+, op(*, num(4), num(2)), num(3)), S3),
    S3 == "4*2+3",
    string(S3).

% --- generate_equation/2, all_equations/2, count_equations/2 ---

test(all_and_count_standard) :-
    all_equations([4,2,5,3], Es),
    Es == ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3","4=2*(5-3)","4=2+(5-3)","4=2+5-3"],
    count_equations([4,2,5,3], 7).

test(two_equal_elements) :-
    all_equations([3,3], Es),
    Es == ["3=3"],
    count_equations([3,3], 1),
    generate_equation([3,3], Eq),
    string(Eq).

test(no_solution_case) :-
    \+ generate_equation([2,3,4], _),
    all_equations([2,3,4], []),
    count_equations([2,3,4], 0).

test(empty_and_single_edge_cases) :-
    \+ generate_equation([], _),
    \+ generate_equation([5], _),
    all_equations([], []),
    all_equations([5], []),
    count_equations([], 0),
    count_equations([5], 0).

test(negative_value_equation) :-
    all_equations([1,3,2,4], Es),
    member("1-3=2-4", Es).

test(zero_safe_no_crash) :-
    all_equations([1,0,0], Es),
    member("1*0=0", Es).

:- end_tests(p2_equations).