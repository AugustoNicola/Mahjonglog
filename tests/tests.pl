:- module(test_hand, []).

% Carga el archivo a testear (mahjong.pl es un archivo consultado, no un módulo)
:- ensure_loaded('../src/mahjong').

% ===================== fichas =====================

:- begin_tests(fichas).

test(palo_man) :- palo(m5, man).
test(palo_pin) :- palo(p5, pin).
test(palo_sou) :- palo(s5, sou).
test(palo_honor_viento) :- palo(n, honor).
test(palo_honor_dragon) :- palo(r, honor).

test(viento_miembros, all(F == [n, s, e, w])) :-
    viento(F).
test(dragon_miembros, all(F == [r, g, wh])) :-
    dragon(F).

test(redfive_man) :- redfive(m5R).
test(redfive_pin) :- redfive(p5R).
test(redfive_sou) :- redfive(s5R).
test(no_es_redfive) :- \+ redfive(m5).

test(numero_valor) :- numero(p7, 7).
test(numero_redfive_conserva_numero) :- numero(m5R, 5).

test(ficha_normal_es_ficha) :- ficha(m1).
test(ficha_honor_es_ficha) :- ficha(r).

:- end_tests(fichas).

% ===================== normal / terminal / noterminal =====================

:- begin_tests(clasificacion).

test(normal_man) :- once(normal(m1)).
test(normal_pin) :- once(normal(p9)).
test(normal_sou) :- once(normal(s5)).
test(normal_excluye_honor) :- \+ normal(r).

test(terminal_bajo) :- once(terminal(m1)).
test(terminal_alto) :- terminal(s9).
test(terminal_excluye_medio) :- \+ terminal(p5).

test(noterminal_medio) :- noterminal(p5).
test(noterminal_excluye_terminal) :- \+ noterminal(m1).

:- end_tests(clasificacion).

% ===================== igualdad de fichas (===) =====================

:- begin_tests(igualdad).

test(misma_ficha_es_igual) :- m3 === m3.
test(mismo_numero_mismo_palo_es_igual) :- m5 === m5.
test(redfive_igual_a_normal) :- m5 === m5R.
test(honor_igual_a_si_mismo) :- once(r === r).
test(distintos_honores_no_son_iguales) :- \+ (r === g).
test(distinto_palo_no_es_igual) :- \+ (m5 === p5).
test(distinto_numero_no_es_igual) :- \+ (m3 === m4).

test(par_usa_igualdad) :- par(m2, m2).
test(par_con_redfive) :- once(par(s5, s5R)).
test(tripla_todas_iguales) :- once(tripla(p7, p7, p7)).
test(tripla_falla_si_no_coincide) :- \+ tripla(p7, p7, p8).

:- end_tests(igualdad).

% ===================== grupos numéricos y escaleras =====================

:- begin_tests(grupos_numericos).

test(mismo_palo_verdadero) :- mismoPalo(m1, m2, m3).
test(mismo_palo_falso) :- \+ mismoPalo(m1, p2, s3).

test(max3_basico) :- max3(1, 5, 3, 5).
test(min3_basico) :- min3(1, 5, 3, 1).

test(max_numero_entre) :- maxNumeroEntre(m1, m5, m3, 5).
test(min_numero_entre) :- minNumeroEntre(m1, m5, m3, 1).

test(sin_numeros_repetidos_verdadero) :- sinNumerosRepetidos(m1, m2, m3).
test(sin_numeros_repetidos_falso_si_hay_repeticion) :- \+ sinNumerosRepetidos(m1, m1, m2).

test(numeros_en_escalera_verdadero) :- numerosEnEscalera(m1, m2, m3).
test(numeros_en_escalera_falso_si_no_consecutivos) :- \+ numerosEnEscalera(m1, m2, m4).

:- end_tests(grupos_numericos).

:- begin_tests(escaleras).

test(escalera_ordenada) :- escalera(m1, m2, m3).
test(escalera_desordenada) :- escalera(m3, m1, m2).
test(escalera_con_redfive) :- escalera(m5R, m6, m7).
test(escalera_falla_con_hueco) :- \+ escalera(m1, m2, m4).
test(escalera_falla_con_distinto_palo) :- \+ escalera(m1, p2, s3).

:- end_tests(escaleras).
