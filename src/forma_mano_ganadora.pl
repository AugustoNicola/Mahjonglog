:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(formas).

%* ===================== Forma de Mano Ganadora =====================

%! manoGanadora(?Mano, ?FormasGanadoras) is nondet.
%* Relaciona Manos que cumplan con la forma de mano ganadora tradicional
%* con FormasGanadoras, la lista de las cinco formas (un par y cuatro
%* juegos) en que se descompuso. Mano = mano(FichasSueltas, Llamadas)
%* (ver victoria.pl).
manoGanadora(mano(FichasSueltas, Llamadas), FormasGanadoras) :-
    ordenarFichas(FichasSueltas, FichasSueltasOrdenadas),
    seleccionarPar(FichasSueltasOrdenadas, RestoFichasSueltas, Par), % el par nunca viene de las llamadas
    compuestaPorJuegos(mano(RestoFichasSueltas, Llamadas), 4, Juegos),
    FormasGanadoras = [Par | Juegos].

%! seleccionarPar(?Fichas, ?RestoFichas, ?Par) is nondet.
%* Relaciona una lista ordenada de fichas con RestoFichas y Par tales que
%* RestoFichas más Par conforman Fichas. Como Fichas está ordenada, las
%* fichas que forman un par quedan siempre adyacentes; así se evita
%* encontrar el mismo par dos veces (una por cada orden de selección de
%* sus fichas).
seleccionarPar(Fichas, RestoFichas, pareja(F1, F2)) :-
    append(Antes, [F1, F2 | Despues], Fichas),
    par(pareja(F1, F2)),
    append(Antes, Despues, RestoFichas).

%! compuestaPorJuegos(?Mano, +CantJuegos, ?Juegos) is nondet.
%* Relaciona una Mano con CantJuegos y Juegos, la lista de los CantJuegos
%* juegos que la componen, si la mano está compuesta exactamente de esa
%* cantidad de juegos, sin fichas sobrantes ni intersecciones. Considera
%* tanto las fichas sueltas como los juegos ya declarados como llamadas
%* (que pasan a Juegos sin modificar).
compuestaPorJuegos(mano([], []), 0, []).
compuestaPorJuegos(mano(FichasSueltas, [Llamada | RestoLlamadas]), CantJuegos, [Llamada | RestoJuegos]) :-
    CantJuegos > 0,
    llamada(Llamada),
    CantJuegosRestante is CantJuegos - 1,
    compuestaPorJuegos(mano(FichasSueltas, RestoLlamadas), CantJuegosRestante, RestoJuegos).
compuestaPorJuegos(mano(FichasSueltas, []), CantJuegos, [Juego | RestoJuegos]) :-
    CantJuegos > 0,
    seleccionarJuego(FichasSueltas, RestoFichasSueltas, Juego),
    CantJuegosRestante is CantJuegos - 1,
    compuestaPorJuegos(mano(RestoFichasSueltas, []), CantJuegosRestante, RestoJuegos).

%! seleccionarJuego(?Fichas, ?RestoFichas, ?Juego) is nondet.
%* Relaciona una lista ordenada de fichas con RestoFichas y Juego (escC o
%* triC) tales que RestoFichas más las fichas de Juego conforman Fichas.
%* Usa combinacion/4 en lugar de encadenar select/3: como fichasDeTripla/3
%* y fichasDeEscalera/3 no dependen del orden de sus argumentos, elegir
%* F2,F3 con select/3 encontraba cada trío válido hasta 6 veces (una por
%* permutación). combinacion/4 genera cada trío de fichas una única vez.
%* Además, fuerza a que la primera ficha de la lista participe del juego
%* elegido: así, en compuestaPorJuegos/3, cada partición en juegos se
%* encuentra una única vez (por el juego que contiene la ficha más a la
%* izquierda) en vez de una vez por cada orden posible de extracción.
seleccionarJuego([F1 | ColaFichas], RestoFichas, escC(F1, F2, F3)) :-
    combinacion(2, ColaFichas, [F2, F3], RestoFichas),
    escalera(escC(F1, F2, F3)).
seleccionarJuego([F1 | ColaFichas], RestoFichas, triC(F1, F2, F3)) :-
    combinacion(2, ColaFichas, [F2, F3], RestoFichas),
    tripla(triC(F1, F2, F3)).
