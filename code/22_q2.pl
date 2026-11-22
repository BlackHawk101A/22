% split_list(+List, -Left, -Right)
% True when List is the concatenation of two non-empty contiguous
% sublists Left and Right in their original order. Fails for lists
% with fewer than two elements.

split_list([X, Y|Rest], [X], [Y|Rest]).
split_list([X, Y|Rest], [X|Left], Right) :-
    split_list([Y|Rest], Left, Right).


% apply_op(?Op, +LeftVal, +RightVal, -Value)
% True when Value is the exact integer result of applying arithmetic
% operator Op (+, -, *, /) to LeftVal and RightVal. Division succeeds
% only when RightVal is non-zero and divides LeftVal evenly.
apply_op(+, L, R, V) :- V is L + R.
apply_op(-, L, R, V) :- V is L - R.
apply_op(*, L, R, V) :- V is L * R.
apply_op(/, L, R, V) :-
    R =\= 0,
    L mod R =:= 0,
    V is L // R.

% build_expr(+Nums, -Tree, -Value)
% True when Tree is a valid binary arithmetic expression tree using
% every number in Nums once in order, and Value is its exact integer value.
build_expr([N], num(N), N).
build_expr(Nums, op(Op, LeftTree, RightTree), Value) :-
    split_list(Nums, LeftNums, RightNums),
    build_expr(LeftNums, LeftTree, LeftVal),
    build_expr(RightNums, RightTree, RightVal),
    apply_op(Op, LeftVal, RightVal, Value).


% op_prec(+Op, -Prec)
% True when Prec is the precedence level of arithmetic operator Op.
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% format_left(+Tree, +ParentPrec, -Str)
% True when Str is the canonical SWI-Prolog string for a left operand Tree
% under a parent operator of precedence ParentPrec. Parenthesized only if
% Tree's top operator has strictly lower precedence than ParentPrec.
format_left(num(N), _, Str) :-
    number_string(N, Str).
format_left(op(Op, L, R), ParentPrec, Str) :-
    op_prec(Op, ChildPrec),
    expr_to_string(op(Op, L, R), Inner),
    (   ChildPrec < ParentPrec
    ->  format(string(Str), "(~s)", [Inner])
    ;   Str = Inner
    ).

% format_right(+Tree, +ParentPrec, -Str)
% True when Str is the canonical SWI-Prolog string for a right operand Tree
% under a parent operator of precedence ParentPrec. Parenthesized if
% Tree's top operator has precedence less than or equal to ParentPrec.
format_right(num(N), _, Str) :-
    number_string(N, Str).
format_right(op(Op, L, R), ParentPrec, Str) :-
    op_prec(Op, ChildPrec),
    expr_to_string(op(Op, L, R), Inner),
    (   ChildPrec =< ParentPrec
    ->  format(string(Str), "(~s)", [Inner])
    ;   Str = Inner
    ).

% expr_to_string(+Tree, -Str)
% True when Str is the canonical, space-free SWI-Prolog string
% representation of expression tree Tree.
expr_to_string(num(N), Str) :-
    number_string(N, Str).
expr_to_string(op(Op, Left, Right), Str) :-
    op_prec(Op, ParentPrec),
    format_left(Left, ParentPrec, LeftStr),
    format_right(Right, ParentPrec, RightStr),
    format(string(Str), "~s~w~s", [LeftStr, Op, RightStr]).

