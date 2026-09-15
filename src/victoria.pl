:- ensure_loaded(fichas).

%* ===================== Victoria =====================
%* Modela el evento de ganar una mano, independiente de la situación de
%* la partida (a diferencia de situacion/3, ver situacion.pl).

%! victoria(?Mano, ?FichaGanadora, ?ModoVictoria) is det.
%* Mano = mano(FichasSueltas, Llamadas) (ver forma_mano_ganadora.pl).
%* FichaGanadora es una de las fichas sueltas que completó la mano.
%* ModoVictoria in {ron, tsumo}.

%! todasLasFichas(+Mano, -Fichas) is det.
%* Relaciona una Mano con la lista de todas sus fichas, tanto las
%* sueltas como las que forman parte de cada llamada.
todasLasFichas(mano(FichasSueltas, Llamadas), Fichas) :-
    maplist(fichasDeLlamada, Llamadas, FichasPorLlamada),
    append([FichasSueltas | FichasPorLlamada], Fichas).

%! fichasDeLlamada(+Llamada, -Fichas) is det.
%* Relaciona una Llamada (chii/pon/kanCerrado/kanAbierto) con la lista
%* de fichas que la componen.
fichasDeLlamada(Llamada, Fichas) :- Llamada =.. [_ | Fichas].
