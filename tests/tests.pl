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

% ===================== combinaciones =====================

:- begin_tests(combinaciones).

test(combinacion_todas, all(Elegidos-Resto == [
        [1,2]-[3], [1,3]-[2], [2,3]-[1]
    ])) :-
    combinacion(2, [1,2,3], Elegidos, Resto).

test(combinacion_cero) :- once(combinacion(0, [1,2,3], [], [1,2,3])).
test(combinacion_completa) :- once(combinacion(3, [1,2,3], [1,2,3], [])).
test(combinacion_conserva_repetidos, all(Elegidos == [[m1,m1], [m1,m2], [m1,m2]])) :-
    combinacion(2, [m1, m1, m2], Elegidos, _).

:- end_tests(combinaciones).

% ===================== orden estándar =====================

:- begin_tests(orden).

test(orden_por_palo) :- ordenarMano([s1, m1, p1], [m1, p1, s1]).
test(orden_por_numero) :- ordenarMano([m3, m1, m2], [m1, m2, m3]).
test(orden_honores) :- ordenarMano([r, e, n, w, s, g, wh], [e, s, w, n, wh, g, r]).
test(orden_redfive_despues_de_normal) :- ordenarMano([s5, s5R, s5], [s5, s5, s5R]).
test(orden_conserva_repetidos) :- ordenarMano([m2, m1, m2, m1], [m1, m1, m2, m2]).
test(orden_mano_mixta) :-
    ordenarMano([s5, p1, s5R, s5, s1, n], [p1, s1, s5, s5, s5R, n]).

:- end_tests(orden).

% ===================== forma de mano ganadora =====================

:- begin_tests(forma_mano_ganadora).

test(seleccionar_par_encuentra_par, all(Resto == [[m3, m4, m5]])) :-
    seleccionarPar([m1, m1, m3, m4, m5], Resto).

test(seleccionar_par_falla_sin_par) :- \+ seleccionarPar([m1, m2, m3], _).

test(seleccionar_par_con_tripla_da_dos_pares_adyacentes) :-
    % En [m1,m1,m1,m2] hay dos pares de m1 adyacentes: (pos.1,2) y (pos.2,3).
    findall(R, seleccionarPar([m1, m1, m1, m2], R), Rs),
    length(Rs, 2).

test(seleccionar_juego_tripla) :- once(seleccionarJuego([m1, m1, m1], [])).
test(seleccionar_juego_escalera) :- once(seleccionarJuego([m1, m2, m3], [])).
test(seleccionar_juego_falla_sin_juego) :- \+ seleccionarJuego([m1, m2, p3], _).

test(seleccionar_juego_unico) :-
    findall(R, seleccionarJuego([m1, m1, m1], R), Rs),
    length(Rs, 1).

test(compuesta_por_cero_juegos_vacia) :- once(compuestaPorJuegos([], 0)).
test(compuesta_por_un_juego) :- once(compuestaPorJuegos([m1, m1, m1], 1)).
test(compuesta_por_dos_juegos) :- once(compuestaPorJuegos([m1, m1, m1, p2, p3, p4], 2)).
test(compuesta_por_juegos_falla_con_sobrantes) :- \+ compuestaPorJuegos([m1, m1, m1, m9], 1).

test(mano_ganadora_triplas) :-
    once(manoGanadora([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n, n])).

test(mano_ganadora_desordenada) :-
    once(manoGanadora([n, n, s8, s7, s6, s5, s5, s5, p4, p3, p2, m1, m1, m1])).

test(mano_ganadora_falla_mano_incompleta) :-
    \+ manoGanadora([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n]).

test(mano_ganadora_falla_sin_par) :-
    \+ manoGanadora([m1, m2, m3, p2, p3, p4, s5, s6, s7, s6, s7, s8, m4, m5]).

test(mano_ganadora_es_unica) :-
    findall(x, manoGanadora([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n, n]), Rs),
    length(Rs, 1).

:- end_tests(forma_mano_ganadora).
