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

% ---- iipeikou ----

manoIipeikouDePrueba([
    pareja(p5, p5), escC(m2, m3, m4), escC(m2, m3, m4), triC(s5, s5, s5), escC(s6, s7, s8)
]).

test(iipeikou_aplica_con_dos_escaleras_iguales) :-
    manoIipeikouDePrueba(Formas), sinFlags(Sit),
    once(yaku(iipeikou, victoria(Formas, p5, tsumo), Sit)).

test(iipeikou_falla_sin_escaleras_repetidas) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    \+ yaku(iipeikou, victoria(Formas, p5, tsumo), Sit).

test(iipeikou_falla_con_llamada) :-
    manoConLlamadaDePrueba(Formas), sinFlags(Sit),
    \+ yaku(iipeikou, victoria(Formas, n, tsumo), Sit).

% ---- ryanpeikou ----

manoRyanpeikouDePrueba([
    pareja(p5, p5), escC(m2, m3, m4), escC(m2, m3, m4), escC(s6, s7, s8), escC(s6, s7, s8)
]).

test(ryanpeikou_aplica_con_dos_pares_de_escaleras_iguales) :-
    manoRyanpeikouDePrueba(Formas), sinFlags(Sit),
    once(yaku(ryanpeikou, victoria(Formas, p5, tsumo), Sit)).

test(ryanpeikou_falla_con_un_solo_par_de_escaleras_iguales) :-
    manoIipeikouDePrueba(Formas), sinFlags(Sit),
    \+ yaku(ryanpeikou, victoria(Formas, p5, tsumo), Sit).

% ---- sanshoku doujun ----

manoSanshokuDePrueba([
    pareja(n, n), escC(m2, m3, m4), escC(p2, p3, p4), escC(s2, s3, s4), triC(s5, s5, s5)
]).

test(sanshoku_aplica_con_misma_escalera_en_tres_palos) :-
    manoSanshokuDePrueba(Formas), sinFlags(Sit),
    once(yaku(sanshokuDoujun, victoria(Formas, n, tsumo), Sit)).

test(sanshoku_falla_sin_los_tres_palos) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    \+ yaku(sanshokuDoujun, victoria(Formas, p5, tsumo), Sit).

% ---- ittsuu ----

manoIttsuuDePrueba([
    pareja(p5, p5), escC(m1, m2, m3), escC(m4, m5, m6), escC(m7, m8, m9), triC(s5, s5, s5)
]).

test(ittsuu_aplica_con_las_tres_escaleras_del_mismo_palo) :-
    manoIttsuuDePrueba(Formas), sinFlags(Sit),
    once(yaku(ittsuu, victoria(Formas, p5, tsumo), Sit)).

test(ittsuu_falla_sin_las_tres_escaleras) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    \+ yaku(ittsuu, victoria(Formas, p5, tsumo), Sit).

% ---- yakuhai: viento de ronda / jugador ----

manoConPiernaVientoDePrueba(Viento, [
    pareja(p5, p5), triC(Viento, Viento, Viento), escC(m2, m3, m4), escC(p2, p3, p4), escC(s6, s7, s8)
]).

test(bakazehai_aplica_con_pierna_del_viento_de_ronda) :-
    manoConPiernaVientoDePrueba(e, Formas),
    once(yaku(bakazehai, victoria(Formas, p5, tsumo), situacion(este, sur, []))).

test(bakazehai_aplica_con_viento_oeste) :-
    manoConPiernaVientoDePrueba(w, Formas),
    once(yaku(bakazehai, victoria(Formas, p5, tsumo), situacion(oeste, sur, []))).

test(bakazehai_falla_si_no_coincide_con_viento_de_ronda) :-
    manoConPiernaVientoDePrueba(e, Formas),
    \+ yaku(bakazehai, victoria(Formas, p5, tsumo), situacion(sur, sur, [])).

test(jikazehai_aplica_con_pierna_del_viento_del_jugador) :-
    manoConPiernaVientoDePrueba(n, Formas),
    once(yaku(jikazehai, victoria(Formas, p5, tsumo), situacion(este, norte, []))).

test(jikazehai_falla_si_no_coincide_con_viento_del_jugador) :-
    manoConPiernaVientoDePrueba(n, Formas),
    \+ yaku(jikazehai, victoria(Formas, p5, tsumo), situacion(este, sur, [])).

% ---- sangenpai (dragones) ----

manoConPiernaDragonDePrueba(Dragon, [
    pareja(p5, p5), triC(Dragon, Dragon, Dragon), escC(m2, m3, m4), escC(p2, p3, p4), escC(s6, s7, s8)
]).

test(chun_aplica_con_pierna_de_dragon_rojo) :-
    manoConPiernaDragonDePrueba(r, Formas), sinFlags(Sit),
    once(yaku(chun, victoria(Formas, p5, tsumo), Sit)).

test(chun_falla_sin_dragon_rojo) :-
    manoConPiernaDragonDePrueba(g, Formas), sinFlags(Sit),
    \+ yaku(chun, victoria(Formas, p5, tsumo), Sit).

test(hatsu_aplica_con_pierna_de_dragon_verde) :-
    manoConPiernaDragonDePrueba(g, Formas), sinFlags(Sit),
    once(yaku(hatsu, victoria(Formas, p5, tsumo), Sit)).

test(hatsu_falla_sin_dragon_verde) :-
    manoConPiernaDragonDePrueba(r, Formas), sinFlags(Sit),
    \+ yaku(hatsu, victoria(Formas, p5, tsumo), Sit).

test(haku_aplica_con_pierna_de_dragon_blanco) :-
    manoConPiernaDragonDePrueba(wh, Formas), sinFlags(Sit),
    once(yaku(haku, victoria(Formas, p5, tsumo), Sit)).

test(haku_falla_sin_dragon_blanco) :-
    manoConPiernaDragonDePrueba(g, Formas), sinFlags(Sit),
    \+ yaku(haku, victoria(Formas, p5, tsumo), Sit).

% ---- shousangen / daisangen ----

manoShousangenDePrueba([
    pareja(r, r), triC(g, g, g), triC(wh, wh, wh), escC(m2, m3, m4), escC(s6, s7, s8)
]).

manoDaisangenDePrueba([
    pareja(p5, p5), triC(r, r, r), triC(g, g, g), triC(wh, wh, wh), escC(m2, m3, m4)
]).

test(shousangen_aplica_con_par_y_dos_piernas_de_dragon) :-
    manoShousangenDePrueba(Formas), sinFlags(Sit),
    once(yaku(shousangen, victoria(Formas, r, tsumo), Sit)).

test(shousangen_falla_con_tres_piernas_de_dragon_sin_par_de_dragon) :-
    manoDaisangenDePrueba(Formas), sinFlags(Sit),
    \+ yaku(shousangen, victoria(Formas, p5, tsumo), Sit).

test(daisangen_aplica_con_tres_piernas_de_dragon) :-
    manoDaisangenDePrueba(Formas), sinFlags(Sit),
    once(yaku(daisangen, victoria(Formas, p5, tsumo), Sit)).

test(daisangen_falla_con_solo_dos_piernas_de_dragon) :-
    manoShousangenDePrueba(Formas), sinFlags(Sit),
    \+ yaku(daisangen, victoria(Formas, r, tsumo), Sit).

% ---- shousuushii / daisuushii ----

manoShousuushiiDePrueba([
    pareja(e, e), triC(s, s, s), triC(w, w, w), triC(n, n, n), escC(m2, m3, m4)
]).

manoDaisuushiiDePrueba([
    pareja(p5, p5), triC(e, e, e), triC(s, s, s), triC(w, w, w), triC(n, n, n)
]).

test(shousuushii_aplica_con_par_y_tres_piernas_de_viento) :-
    manoShousuushiiDePrueba(Formas), sinFlags(Sit),
    once(yaku(shousuushii, victoria(Formas, e, tsumo), Sit)).

test(shousuushii_falla_con_cuatro_piernas_de_viento_sin_par_de_viento) :-
    manoDaisuushiiDePrueba(Formas), sinFlags(Sit),
    \+ yaku(shousuushii, victoria(Formas, p5, tsumo), Sit).

test(daisuushii_aplica_con_cuatro_piernas_de_viento) :-
    manoDaisuushiiDePrueba(Formas), sinFlags(Sit),
    once(yaku(daisuushii, victoria(Formas, p5, tsumo), Sit)).

test(daisuushii_falla_con_solo_tres_piernas_de_viento) :-
    manoShousuushiiDePrueba(Formas), sinFlags(Sit),
    \+ yaku(daisuushii, victoria(Formas, e, tsumo), Sit).

% ---- chanta / junchan / honroutou / chinroutou / tsuuiisou ----

manoChantaDePrueba([
    pareja(n, n), chii(m1, m2, m3), escC(p7, p8, p9), triC(s1, s1, s1), escC(s7, s8, s9)
]).

manoJunchanDePrueba([
    pareja(p1, p1), chii(m1, m2, m3), escC(p7, p8, p9), triC(s1, s1, s1), escC(s7, s8, s9)
]).

manoHonroutouDePrueba([
    pareja(n, n), triC(s1, s1, s1), triC(m9, m9, m9), triC(p1, p1, p1), triC(r, r, r)
]).

manoChinroutouDePrueba([
    pareja(p1, p1), triC(m1, m1, m1), triC(m9, m9, m9), triC(s1, s1, s1), triC(s9, s9, s9)
]).

manoTsuuiisouDePrueba([
    pareja(n, n), triC(e, e, e), triC(s, s, s), triC(r, r, r), triC(g, g, g)
]).

test(chanta_aplica_con_terminal_u_honor_en_cada_forma) :-
    manoChantaDePrueba(Formas), sinFlags(Sit),
    once(yaku(chanta, victoria(Formas, n, ron), Sit)).

test(chanta_falla_con_forma_toda_simples) :-
    manoTanyaoDePrueba(Formas), sinFlags(Sit),
    \+ yaku(chanta, victoria(Formas, p5, tsumo), Sit).

test(junchan_aplica_con_terminal_en_cada_forma_sin_honores) :-
    manoJunchanDePrueba(Formas), sinFlags(Sit),
    once(yaku(junchan, victoria(Formas, p1, ron), Sit)).

test(junchan_falla_con_par_de_honores) :-
    manoChantaDePrueba(Formas), sinFlags(Sit),
    \+ yaku(junchan, victoria(Formas, n, ron), Sit).

test(honroutou_aplica_con_solo_terminales_y_honores) :-
    manoHonroutouDePrueba(Formas), sinFlags(Sit),
    once(yaku(honroutou, victoria(Formas, n, tsumo), Sit)).

test(honroutou_falla_con_escalera) :-
    manoChantaDePrueba(Formas), sinFlags(Sit),
    \+ yaku(honroutou, victoria(Formas, n, ron), Sit).

test(chinroutou_aplica_con_solo_terminales) :-
    manoChinroutouDePrueba(Formas), sinFlags(Sit),
    once(yaku(chinroutou, victoria(Formas, p1, tsumo), Sit)).

test(chinroutou_falla_con_honores) :-
    manoHonroutouDePrueba(Formas), sinFlags(Sit),
    \+ yaku(chinroutou, victoria(Formas, n, tsumo), Sit).

test(tsuuiisou_aplica_con_solo_honores) :-
    manoTsuuiisouDePrueba(Formas), sinFlags(Sit),
    once(yaku(tsuuiisou, victoria(Formas, n, tsumo), Sit)).

test(tsuuiisou_falla_con_terminales_numericos) :-
    manoChinroutouDePrueba(Formas), sinFlags(Sit),
    \+ yaku(tsuuiisou, victoria(Formas, p1, tsumo), Sit).

:- end_tests(yakus).
