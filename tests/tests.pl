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

test(par_usa_igualdad) :- fichasDePareja(m2, m2).
test(par_con_redfive) :- once(fichasDePareja(s5, s5R)).
test(tripla_todas_iguales) :- once(fichasDeTripla(p7, p7, p7)).
test(tripla_falla_si_no_coincide) :- \+ fichasDeTripla(p7, p7, p8).

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

test(escalera_ordenada) :- fichasDeEscalera(m1, m2, m3).
test(escalera_desordenada) :- fichasDeEscalera(m3, m1, m2).
test(escalera_con_redfive) :- fichasDeEscalera(m5R, m6, m7).
test(escalera_falla_con_hueco) :- \+ fichasDeEscalera(m1, m2, m4).
test(escalera_falla_con_distinto_palo) :- \+ fichasDeEscalera(m1, p2, s3).

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

test(orden_por_palo) :- ordenarFichas([s1, m1, p1], [m1, p1, s1]).
test(orden_por_numero) :- ordenarFichas([m3, m1, m2], [m1, m2, m3]).
test(orden_honores) :- ordenarFichas([r, e, n, w, s, g, wh], [e, s, w, n, wh, g, r]).
test(orden_redfive_despues_de_normal) :- ordenarFichas([s5, s5R, s5], [s5, s5, s5R]).
test(orden_conserva_repetidos) :- ordenarFichas([m2, m1, m2, m1], [m1, m1, m2, m2]).
test(orden_mano_mixta) :-
    ordenarFichas([s5, p1, s5R, s5, s1, n], [p1, s1, s5, s5, s5R, n]).

test(fichas_en_orden_verdadero) :- fichasEnOrden([m1, m2, m3]).
test(fichas_en_orden_falso) :- \+ fichasEnOrden([m2, m1, m3]).

:- end_tests(orden).

% ===================== formas =====================

:- begin_tests(formas).

% ---- pares ----

test(par_valido) :- par(pareja(n, n)).
test(par_falla_distintas) :- \+ par(pareja(m1, m2)).
test(par_falla_desordenado) :- \+ par(pareja(m2, m1)).

% ---- escaleras: chii (llamada) y escC (oculta) ----

test(chii_valido) :- llamada(chii(m1, m2, m3)).
test(chii_es_escalera) :- escalera(chii(m1, m2, m3)).
test(chii_no_es_oculta) :- \+ oculta(chii(m1, m2, m3)).
test(chii_falla_desordenado) :- \+ llamada(chii(m2, m1, m3)).
test(chii_falla_sin_escalera) :- \+ llamada(chii(m1, m2, m4)).

test(escC_valida) :- oculta(escC(m1, m2, m3)).
test(escC_es_escalera) :- escalera(escC(m1, m2, m3)).
test(escC_no_es_llamada) :- \+ llamada(escC(m1, m2, m3)).

% ---- triplas estrictas: pon (llamada) y triC (oculta) ----

test(pon_valido) :- llamada(pon(n, n, n)).
test(pon_es_tripla) :- tripla(pon(n, n, n)).
test(pon_es_pierna) :- once(pierna(pon(n, n, n))).
test(pon_no_es_quad) :- \+ quad(pon(n, n, n)).
test(pon_es_unico) :-
    findall(x, llamada(pon(n, n, n)), Rs),
    length(Rs, 1).
test(pon_falla_sin_tripla) :- \+ llamada(pon(m1, m1, m2)).

test(triC_valida) :- oculta(triC(m1, m1, m1)).
test(triC_es_tripla) :- tripla(triC(m1, m1, m1)).
test(triC_es_pierna) :- once(pierna(triC(m1, m1, m1))).
test(triC_no_es_llamada) :- \+ llamada(triC(m1, m1, m1)).

% ---- quads: kanA (llamada) y kanC (oculta) ----

test(kanA_valido) :- llamada(kanA(m1, m1, m1, m1)).
test(kanA_es_quad) :- quad(kanA(m1, m1, m1, m1)).
test(kanA_es_pierna) :- pierna(kanA(m1, m1, m1, m1)).
test(kanA_no_es_tripla) :- \+ tripla(kanA(m1, m1, m1, m1)).

test(kanC_valido) :- oculta(kanC(m1, m1, m1, m1)).
test(kanC_es_quad) :- quad(kanC(m1, m1, m1, m1)).
test(kanC_es_pierna) :- pierna(kanC(m1, m1, m1, m1)).
test(kanC_no_es_llamada) :- \+ llamada(kanC(m1, m1, m1, m1)).

test(kan_falla_sin_cuarta_igual) :- \+ oculta(kanC(m1, m1, m1, m2)).

% ---- juego y forma: agregación de las categorías anteriores ----

test(juego_incluye_escalera) :- once(juego(chii(m1, m2, m3))).
test(juego_incluye_tripla) :- once(juego(pon(n, n, n))).
test(juego_incluye_quad) :- once(juego(kanA(m1, m1, m1, m1))).
test(juego_falla_para_par) :- \+ juego(pareja(n, n)).

test(forma_incluye_par) :- once(forma(pareja(n, n))).
test(forma_incluye_juego) :- once(forma(triC(m1, m1, m1))).

:- end_tests(formas).

% ===================== forma de mano ganadora =====================

:- begin_tests(forma_mano_ganadora).

test(seleccionar_par_encuentra_par, all(Resto == [[m3, m4, m5]])) :-
    seleccionarPar([m1, m1, m3, m4, m5], Resto, _).

test(seleccionar_par_encuentra_pareja_correcta) :-
    once(seleccionarPar([m1, m1, m3, m4, m5], _, pareja(m1, m1))).

test(seleccionar_par_falla_sin_par) :- \+ seleccionarPar([m1, m2, m3], _, _).

test(seleccionar_par_con_tripla_da_dos_pares_adyacentes) :-
    % En [m1,m1,m1,m2] hay dos pares de m1 adyacentes: (pos.1,2) y (pos.2,3).
    findall(R, seleccionarPar([m1, m1, m1, m2], R, _), Rs),
    length(Rs, 2).

test(seleccionar_juego_tripla) :- once(seleccionarJuego([m1, m1, m1], [], triC(m1, m1, m1))).
test(seleccionar_juego_escalera) :- once(seleccionarJuego([m1, m2, m3], [], escC(m1, m2, m3))).
test(seleccionar_juego_falla_sin_juego) :- \+ seleccionarJuego([m1, m2, p3], _, _).

test(seleccionar_juego_unico) :-
    findall(J, seleccionarJuego([m1, m1, m1], _, J), Js),
    length(Js, 1).

test(compuesta_por_cero_juegos_vacia) :- once(compuestaPorJuegos(mano([], []), 0, [])).
test(compuesta_por_un_juego_suelto) :- once(compuestaPorJuegos(mano([m1, m1, m1], []), 1, [triC(m1, m1, m1)])).
test(compuesta_por_dos_juegos_sueltos) :-
    once(compuestaPorJuegos(mano([m1, m1, m1, p2, p3, p4], []), 2, [triC(m1, m1, m1), escC(p2, p3, p4)])).
test(compuesta_por_juegos_falla_con_sobrantes) :- \+ compuestaPorJuegos(mano([m1, m1, m1, m9], []), 1, _).

test(compuesta_por_juegos_cuenta_llamadas) :-
    once(compuestaPorJuegos(mano([m1, m1, m1], [pon(n, n, n)]), 2, [pon(n, n, n), triC(m1, m1, m1)])).
test(compuesta_por_juegos_falla_llamada_invalida) :-
    \+ compuestaPorJuegos(mano([m1, m1, m1], [pon(m1, m1, m2)]), 2, _).

% ---- manoGanadora: hands are mano(FichasSueltas, Llamadas) ----

test(mano_ganadora_triplas) :-
    once(manoGanadora(mano([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n, n], []), _)).

test(mano_ganadora_desordenada) :-
    once(manoGanadora(mano([n, n, s8, s7, s6, s5, s5, s5, p4, p3, p2, m1, m1, m1], []), _)).

test(mano_ganadora_falla_mano_incompleta) :-
    \+ manoGanadora(mano([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n], []), _).

test(mano_ganadora_falla_sin_par) :-
    \+ manoGanadora(mano([m1, m2, m3, p2, p3, p4, s5, s6, s7, s6, s7, s8, m4, m5], []), _).

test(mano_ganadora_es_unica) :-
    findall(x, manoGanadora(mano([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n, n], []), _), Rs),
    length(Rs, 1).

test(mano_ganadora_forma_correcta) :-
    once(manoGanadora(mano([m1, m1, m1, p2, p3, p4, s5, s5, s5, s6, s7, s8, n, n], []), Formas)),
    Formas == [pareja(n, n), triC(m1, m1, m1), escC(p2, p3, p4), triC(s5, s5, s5), escC(s6, s7, s8)].

test(mano_ganadora_con_llamadas) :-
    % El par nunca viene de las llamadas: n,n queda en FichasSueltas.
    once(manoGanadora(mano([p2, p3, p4, s5, s5, s5, n, n], [pon(m1, m1, m1), chii(s6, s7, s8)]), _)).

test(mano_ganadora_falla_si_par_viene_de_llamada) :-
    \+ manoGanadora(mano([m3, m4, m5, s5, s5, s5, s6, s7, s8], [pon(n, n, n), pon(m1, m1, m1)]), _).

:- end_tests(forma_mano_ganadora).

% ===================== situación =====================

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
