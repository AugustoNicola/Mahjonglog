:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(victoria).
:- ensure_loaded(situacion).

%* ===================== Yakus =====================
%! yaku(+Yaku, +Victoria, +Situacion) is semidet.
%* Relaciona yakus que aplican a esta victoria bajo esta situación.
%* victoria/3 y situacion/3 se documentan en victoria.pl y situacion.pl.


%* ===================== Tanyao =====================
yaku(tanyao, Victoria, Situacion) :- 
    victoriaValida(Victoria),
    situacionValida(Situacion),
    Victoria = victoria(Formas, _, _),
    todasLasFichas(Formas, Fichas),
    \+ (member(F, Fichas), \+ simple(F)).



%* ===================== Menzen Tsumo =====================
yaku(menzenTsumo, Victoria, Situacion) :- 
    victoriaValida(Victoria),
    situacionValida(Situacion),
    Victoria = victoria(Formas, _, tsumo),
    \+ (member(Forma, Formas), llamada(Forma)).
