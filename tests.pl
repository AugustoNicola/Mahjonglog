
:- begin_tests(mahjong).
:- ensure_loaded(mahjong).

test(matriz, [nondet]) :-
    matriz(2, 3, M),
    M =@= [[_, _, _], [_, _, _]].

:- end_tests(mahjong).

