% Tests de src/yakus.pl: condiciones de cada yaku.

:- begin_tests(yakus).

manoTanyaoDePrueba([
    pareja(p5, p5), escC(m2, m3, m4), escC(p2, p3, p4), triC(s5, s5, s5), escC(s6, s7, s8)
]).

manoConTerminalDePrueba([
    pareja(n, n), escC(m1, m2, m3), escC(p2, p3, p4), triC(s5, s5, s5), escC(s6, s7, s8)
]).

manoConLlamadaDePrueba([
    pareja(n, n), chii(m2, m3, m4), escC(p2, p3, p4), triC(s5, s5, s5), escC(s6, s7, s8)
]).

sinFlags(situacion(este, sur, [])).

% ---- tanyao ----

test(tanyao_aplica_a_mano_toda_simples) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    once(yaku(tanyao, victoria(Formas, p5, tsumo), Sit)).

test(tanyao_falla_con_terminal) :-
    manoConTerminalDePrueba(Formas), sinFlags(Sit),
    \+ yaku(tanyao, victoria(Formas, n, tsumo), Sit).

test(tanyao_falla_con_honor_en_el_par) :-
    manoConLlamadaDePrueba(Formas), sinFlags(Sit),
    \+ yaku(tanyao, victoria(Formas, n, ron), Sit).

% ---- menzen tsumo ----

test(menzen_tsumo_aplica_a_mano_cerrada_por_tsumo) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    once(yaku(menzenTsumo, victoria(Formas, p5, tsumo), Sit)).

test(menzen_tsumo_falla_con_llamada) :-
    manoConLlamadaDePrueba(Formas), sinFlags(Sit),
    \+ yaku(menzenTsumo, victoria(Formas, n, tsumo), Sit).

test(menzen_tsumo_falla_con_ron) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    \+ yaku(menzenTsumo, victoria(Formas, p5, ron), Sit).

:- end_tests(yakus).
