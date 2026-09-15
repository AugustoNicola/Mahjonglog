:- ensure_loaded(juegos).

%! llamada(+Llamada) is nondet.
%* Relaciona llamadas válidas según los términos dedicados (chii, pon, kanAbierto y kanCerrado).
%* Requiere que los elementos del juego estén en orden.

llamada(chii(F1, F2, F3)) :- escalera(F1, F2, F3), fichasEnOrden([F1, F2, F3]).

llamada(pon(F1, F2, F3)) :- tripla(F1, F2, F3), fichasEnOrden([F1, F2, F3]).

llamada(kanCerrado(F1, F2, F3, F4)) :- tripla(F1, F2, F3), F4 === F1, fichasEnOrden([F1, F2, F3, F4]).
llamada(kanAbierto(F1, F2, F3, F4)) :- tripla(F1, F2, F3), F4 === F1, fichasEnOrden([F1, F2, F3, F4]).