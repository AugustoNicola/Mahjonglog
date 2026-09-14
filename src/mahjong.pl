%* ===================== definiciones atributos de las fichas =====================
palo(s1, sou). palo(s2, sou). palo(s3, sou). palo(s4, sou). palo(s5, sou). palo(s5R, sou). palo(s6, sou). palo(s7, sou). palo(s8, sou). palo(s9, sou). 
palo(m1, man). palo(m2, man). palo(m3, man). palo(m4, man). palo(m5, man). palo(m5R, man). palo(m6, man). palo(m7, man). palo(m8, man). palo(m9, man).
palo(p1, pin). palo(p2, pin). palo(p3, pin). palo(p4, pin). palo(p5, pin). palo(p5R, pin). palo(p6, pin). palo(p7, pin). palo(p8, pin). palo(p9, pin).
palo(n, honor). palo(s, honor). palo(e, honor). palo(w, honor).
palo(r, honor). palo(g, honor). palo(wh, honor).

redfive(s5R). redfive(m5R). redfive(p5R).

numero(s1, 1). numero(s2, 2). numero(s3, 3). numero(s4, 4). numero(s5, 5). numero(s5R, 5). numero(s6, 6). numero(s7, 7). numero(s8, 8). numero(s9, 9).
numero(m1, 1). numero(m2, 2). numero(m3, 3). numero(m4, 4). numero(m5, 5). numero(m5R, 5). numero(m6, 6). numero(m7, 7). numero(m8, 8). numero(m9, 9).
numero(p1, 1). numero(p2, 2). numero(p3, 3). numero(p4, 4). numero(p5, 5). numero(p5R, 5). numero(p6, 6). numero(p7, 7). numero(p8, 8). numero(p9, 9).

viento(n). viento(s). viento(e). viento(w).
dragon(r). dragon(g). dragon(wh).

normal(F) :- palo(F, sou).
normal(F) :- palo(F, pin).
normal(F) :- palo(F, man).

terminal(F) :- numero(F, 1).
terminal(F) :- numero(F, 9).

noterminal(F) :- numero(F, N), between(2,8,N).

ficha(F) :- palo(F, _).

%* ===================== Igualdad de Fichas =====================
:- op(700, xfx, ===).
%! ===(F1, F2) is nondet.
%* Relaciona fichas iguales (en el sentido de compratir palo y número, i.e. servir para un par). No distingue red fives.
F === F :- palo(F, honor).
F1 === F2 :- normal(F1), palo(F1, P), numero(F1, N), palo(F2, P), numero(F2, N).

%* ===================== Juegos de Pares y Triplas =====================
%! par(?F1, ?F2) is nondet.
%* Relaciona dos fichas iguales, igual que ===/2.
par(F1, F2) :- F1 === F2.

%! tripla(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas iguales, igual que ===/2.
tripla(F1, F2, F3) :- F1 === F2, F2 === F3.

%* ===================== Juegos de Escaleras =====================
%! escalera(?F1, ?F2, ?F3) is nondet.
%* Relaciona tres fichas que forman una escalera, sin importar el orden relativo.
escalera(F1, F2, F3) :- mismoPalo(F1, F2, F3), numerosEnEscalera(F1, F2, F3).

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

%par(F, F) :- ficha(F), not(redfive(F)).
%par(F, F) :- ficha(F),  redfive(F)
%tripla(F, F, F) :- ficha(F).




%! shanten(+Mano, +Robada, ?Yaku, -N).
%shanten([m3,m4,m5,s6,s6,s6,p3,p4,r,r,r,s,s], p2, pinfu, N).