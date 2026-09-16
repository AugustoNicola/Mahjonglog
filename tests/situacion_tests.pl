% Tests de src/situacion.pl: estado de la partida al momento de ganar.

:- begin_tests(situacion).

test(tiene_flag_presente) :- tieneFlag(situacion(este, sur, [riichi, ippatsu]), ippatsu).
test(tiene_flag_ausente) :- \+ tieneFlag(situacion(este, sur, [riichi]), ippatsu).
test(tiene_flag_lista_vacia) :- \+ tieneFlag(situacion(este, sur, []), riichi).

test(viento_valido, all(V == [este, sur, oeste, norte])) :- vientoValido(V).

test(situacion_valida_sin_flags) :- situacionValida(situacion(este, sur, [])).
test(situacion_valida_con_riichi_ippatsu) :- situacionValida(situacion(este, este, [riichi, ippatsu])).
test(situacion_valida_con_doble_riichi) :- situacionValida(situacion(oeste, norte, [doble_riichi])).

test(situacion_invalida_viento_ronda) :- \+ situacionValida(situacion(centro, sur, [])).
test(situacion_invalida_viento_jugador) :- \+ situacionValida(situacion(este, centro, [])).

test(situacion_invalida_flag_no_soportado) :- \+ situacionValida(situacion(este, sur, [tenhou])).

test(situacion_invalida_riichi_y_doble_riichi) :-
    \+ situacionValida(situacion(este, sur, [riichi, doble_riichi])).
test(situacion_invalida_houtei_y_haitei) :-
    \+ situacionValida(situacion(este, sur, [houtei, haitei])).
test(situacion_invalida_houtei_y_rinshan) :-
    \+ situacionValida(situacion(este, sur, [houtei, rinshan])).
test(situacion_invalida_chankan_y_rinshan) :-
    \+ situacionValida(situacion(este, sur, [chankan, rinshan])).
test(situacion_invalida_chankan_y_haitei) :-
    \+ situacionValida(situacion(este, sur, [chankan, haitei])).

test(situacion_invalida_ippatsu_sin_riichi) :-
    \+ situacionValida(situacion(este, sur, [ippatsu])).
test(situacion_valida_ippatsu_con_doble_riichi) :-
    situacionValida(situacion(este, sur, [doble_riichi, ippatsu])).

:- end_tests(situacion).
