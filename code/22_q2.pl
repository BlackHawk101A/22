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