% Tests de src/forma_mano_ganadora.pl: descomposición de una mano ganadora
% en un par y cuatro juegos.

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

% ---- todasLasFichas / fichasDeForma ----

test(todas_las_fichas_aplana_formas) :-
    once(todasLasFichas(
        [pareja(n, n), triC(m1, m1, m1), escC(p2, p3, p4), triC(s5, s5, s5), escC(s6, s7, s8)],
        Fichas)),
    length(Fichas, 14).

test(fichas_de_forma_pareja) :- once(fichasDeForma(pareja(n, n), [n, n])).
test(fichas_de_forma_triC) :- once(fichasDeForma(triC(m1, m1, m1), [m1, m1, m1])).

:- end_tests(forma_mano_ganadora).
