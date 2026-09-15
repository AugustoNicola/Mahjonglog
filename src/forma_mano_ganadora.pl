:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(llamadas).

%* ===================== Forma de Mano Ganadora =====================

%! manoGanadora(?Mano) is nondet.
%* Relaciona Manos que cumplan con la forma de mano ganadora tradicional.
%* Una mano ganadora consta de cuatro juegos (pares, triplas o escaleras) y un par.
manoGanadora(Mano) :- 
    Mano =.. [mano, FichasSueltas, Llamadas],
    ordenarFichas(FichasSueltas, FichasSueltasOrdenadas),
    seleccionarPar(FichasSueltasOrdenadas, RestoFichasSueltas), % el par nunca viene de las llamadas
    compuestaPorJuegos(mano(RestoFichasSueltas, Llamadas), 4).

%! seleccionarPar(?Fichas, ?RestoFichas) is nondet.
%* Relaciona una lista ordenada de fichas con otra tal que la segunda más un par conformen la primera.
%* Como está ordenada, las fichas que forman un par quedan siempre adyacentes; así se evita encontrar el
%* mismo par dos veces (una por cada orden de selección de sus fichas).
seleccionarPar(Fichas, RestoFichas) :-
    append(Antes, [F1, F2 | Despues], Fichas),
    par(F1, F2),
    append(Antes, Despues, RestoFichas).
    
%! compuestaPorJuegos(?Mano, +CantJuegos) is nondet.
%* Relaciona una Mano con CantJuegos si la mano está compuesta
%* exactamente de CantJuegos juegos, sin fichas sobrantes ni intersecciones.
%* Considera tanto las fichas cerradas como los juegos declarados.
compuestaPorJuegos(mano([], []), 0).
compuestaPorJuegos(mano(FichasSueltas, [Llamada|RestoLlamadas]), CantJuegos) :-
    CantJuegos > 0,
    llamada(Llamada),
    CantJuegosRestante is CantJuegos - 1,
    compuestaPorJuegos(mano(FichasSueltas, RestoLlamadas), CantJuegosRestante).
compuestaPorJuegos(mano(FichasSueltas, []), CantJuegos) :-
    CantJuegos > 0,
    seleccionarJuego(FichasSueltas, RestoFichasSueltas),
    CantJuegosRestante is CantJuegos - 1,
    compuestaPorJuegos(mano(RestoFichasSueltas, []), CantJuegosRestante).

%! seleccionarJuego(?Fichas, ?RestoFichas) is nondet.
%* Relaciona una lista ordenada de fichas con otra tal que la segunda más un juego (tripla/escalera) conformen la primera.
%* Usa combinacion/4 en lugar de encadenar select/3: como tripla/3 y
%* escalera/3 no dependen del orden de sus argumentos, elegir F1,F2,F3 con
%* select/3 encontraba cada trío válido hasta 6 veces (una por permutación).
%* combinacion/4 genera cada trío de fichas una única vez.
%* Además, fuerza a que la primera ficha de la lista participe del juego
%* elegido: así, en compuestaPorJuegos/2, cada partición en juegos se
%* encuentra una única vez (por el juego que contiene la ficha más a la
%* izquierda) en vez de una vez por cada orden posible de extracción.
seleccionarJuego([F1 | ColaFichas], RestoFichas) :-
    combinacion(2, ColaFichas, [F2, F3], RestoFichas),
    juego(F1, F2, F3).