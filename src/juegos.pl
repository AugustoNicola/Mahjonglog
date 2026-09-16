:- ensure_loaded(fichas).

%* ===================== Juegos de Pares y Triplas =====================
%! fichasDePareja(?F1, ?F2) is nondet.
%* Relaciona dos fichas que conforman un par, es decir iguales según ===/2.
fichasDePareja(F1, F2) :- F1 === F2.

%! fichasDeTripla(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas que conforman una tripla, es decir iguales según ===/2.
fichasDeTripla(F1, F2, F3) :- F1 === F2, F2 === F3.

%* ===================== Juegos de Escaleras =====================
%! fichasDeEscalera(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas que conforman una escalera, sin importar el orden relativo.
fichasDeEscalera(F1, F2, F3) :- mismoPalo(F1, F2, F3), numerosEnEscalera(F1, F2, F3).

%! mismoPalo(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas del mismo palo.
mismoPalo(F1, F2, F3) :- palo(F1, P), palo(F2, P), palo(F3, P).

%! numerosEnEscalera(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas cuyos números forman una escalera (aunque el palo no sea el mismo).
numerosEnEscalera(F1, F2, F3) :- sinNumerosRepetidos(F1, F2, F3),
    maxNumeroEntre(F1, F2, F3, Max), minNumeroEntre(F1, F2, F3, Min), (Max - Min) =:= 2.

%! sinNumerosRepetidos(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas con números distintos.
sinNumerosRepetidos(F1, F2, F3) :- numero(F1, N1), numero(F2, N2), numero(F3, N3), N1 \= N2, N2 \= N3, N1 \= N3.

%! maxNumeroEntre(?F1, ?F2, ?F3, -Max) is nondet.
%* Relaciona a tres fichas numéricas con el máximo número entre las tres.
maxNumeroEntre(F1, F2, F3, Max) :- numero(F1, N1), numero(F2, N2), numero(F3, N3), max3(N1, N2, N3, Max).

%! minNumeroEntre(?F1, ?F2, ?F3, -Min) is nondet.
%* Relaciona a tres fichas numéricas con el mínimo número entre las tres.
minNumeroEntre(F1, F2, F3, Min) :- numero(F1, N1), numero(F2, N2), numero(F3, N3), min3(N1, N2, N3, Min).

%! max3(+X, +Y, +Z, ?Max)
max3(X, Y, Z, Max) :-
    Max is max(X, max(Y, Z)).

%! min3(+X, +Y, +Z, ?Min)
min3(X, Y, Z, Min) :-
    Min is min(X, min(Y, Z)).

%* ===================== Combinaciones =====================
%! combinacion(+N, +Lista, -Elegidos, -Resto) is nondet.
%* Relaciona Elegidos, un sub-multiconjunto de tamaño N de Lista, con Resto,
%* los elementos restantes, preservando el orden relativo de Lista.
%* A diferencia de encadenar select/3 (que elige N posiciones en cualquier
%* orden), cada combinación de N elementos se genera una única vez, ya que
%* recorre Lista de una sola pasada decidiendo para cada ficha si entra en
%* Elegidos o queda en Resto.
combinacion(0, Resto, [], Resto).
combinacion(N, [X|Xs], [X|Ys], Resto) :-
    N > 0,
    N1 is N - 1,
    combinacion(N1, Xs, Ys, Resto).
combinacion(N, [X|Xs], Ys, [X|Resto]) :-
    N > 0,
    combinacion(N, Xs, Ys, Resto).
