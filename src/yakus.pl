:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(victoria).
:- ensure_loaded(situacion).

%* ===================== Yakus =====================
%* Cada yaku sigue la firma <nombreYaku>(+Victoria, +Situacion) is semidet,
%* e indica si ese yaku aplica a esa victoria bajo esa situación.
%* victoria/3 y situacion/3 se documentan en victoria.pl y situacion.pl.

%! tanyao(+Victoria, +Situacion) is semidet.
%* Aplica si ninguna ficha de la mano (sueltas o en llamadas) es terminal
%* ni honor, es decir, todas las fichas son noterminal/1.
%* (normal/1 no alcanza: sólo excluye honores, no terminales como m1/m9).
tanyao(victoria(Mano, _, _), _) :-
    todasLasFichas(Mano, Fichas),
    \+ (member(F, Fichas), \+ noterminal(F)).

%! ippatsu(+Victoria, +Situacion) is semidet.
%* Aplica si la Situacion tiene el flag ippatsu. No depende de la mano
%* ni de la ficha ganadora.
ippatsu(_, Situacion) :- tieneFlag(Situacion, ippatsu).
