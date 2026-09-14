:- ensure_loaded(juegos).
:- ensure_loaded(orden).

%* ===================== Forma de Mano Ganadora =====================

%! manoGanadora(?Mano) is nondet.
%* Relaciona Manos (lista de fichas ordenadas) que cumplan con la forma de mano ganadora tradicional.
%* Una mano ganadora consta de cuatro juegos (pares, triplas o escaleras) y un par.
manoGanadora(Mano) :- 
    ordenarMano(Mano, ManoOrdenada),
    seleccionarPar(ManoOrdenada, RestoManoOrdenada),
    compuestaPorJuegos(RestoManoOrdenada, 4).

%! seleccionarPar(?Mano, ?RestoMano) is nondet.
%* Relaciona una Mano (lista de fichas ordenada) con otra tal que la segunda más un par conformen la primera.
%* Como está ordenada, las fichas que forman un par quedan siempre adyacentes; así se evita encontrar el
%* mismo par dos veces (una por cada orden de selección de sus fichas).
seleccionarPar(Mano, RestoMano) :-
    append(Antes, [F1, F2 | Despues], Mano),
    par(F1, F2),
    append(Antes, Despues, RestoMano).
    
%! compuestaPorJuegos(?Mano, +CantJuegos) is nondet.
%* Relaciona una Mano (lista de fichas ordenada) con CantJuegos si la mano está compuesta
%* exactamente de CantJuegos juegos, sin fichas sobrantes ni intersecciones.
compuestaPorJuegos([], 0).
compuestaPorJuegos(Mano, CantJuegos) :-
    CantJuegos > 0,
    seleccionarJuego(Mano, RestoMano),
    CantJuegosRestante is CantJuegos - 1,
    compuestaPorJuegos(RestoMano, CantJuegosRestante).

%! seleccionarJuego(?Mano, ?RestoMano) is nondet.
%* Relaciona una Mano (lista de fichas ordenada) con otra tal que la segunda más un juego (tripla/escalera) conformen la primera.
%* Usa combinacion/4 en lugar de encadenar select/3: como tripla/3 y
%* escalera/3 no dependen del orden de sus argumentos, elegir F1,F2,F3 con
%* select/3 encontraba cada trío válido hasta 6 veces (una por permutación).
%* combinacion/4 genera cada trío de fichas una única vez.
%* Además, fuerza a que la primera ficha de Mano participe del juego
%* elegido: así, en compuestaPorJuegos/2, cada partición en juegos se
%* encuentra una única vez (por el juego que contiene la ficha más a la
%* izquierda) en vez de una vez por cada orden posible de extracción.
seleccionarJuego([F1 | ColaMano], RestoMano) :-
    combinacion(2, ColaMano, [F2, F3], RestoMano),
    juego(F1, F2, F3).