:- ensure_loaded(fichas).
:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(victoria).
:- ensure_loaded(situacion).

%* ===================== Yakus =====================
%! yaku(?Yaku, +Victoria, +Situacion) is semidet.
%* Relaciona yakus que aplican a esta victoria bajo esta situación.
%* No se concierne con la compatibilidad de yakus: e.g. una mano con ryanpeikou 
%* sigue teniendo el yaku iipeikou.
% TODO manejar compatibilidad posteriormente.
%* victoria/3 y situacion/3 se documentan en victoria.pl y situacion.pl.

%* ===================== Iipeikou (Pure Double Sequence) =====================
yaku(iipeikou, victoria(Formas, _, _), _) :- 
    manoCerrada(Formas),
    select(escC(A1,A2,A3), Formas, RestoFormas),
    member(escC(B1,B2,B3), RestoFormas),
    A1 === B1, A2 === B2, A3 === B3.

%* ===================== Ryanpeikou (Twice Pure Double Sequences) =====================
yaku(ryanpeikou, victoria(Formas, _, _), _) :- 
    manoCerrada(Formas),
    select(escC(A1,A2,A3), Formas, FormasSin1),
    select(escC(B1,B2,B3), FormasSin1, FormasSin2),
    A1 === B1, A2 === B2, A3 === B3,
    select(escC(C1,C2,C3), FormasSin2, FormasSin3),
    member(escC(D1,D2,D3), FormasSin3),
    C1 === D1, C2 === D2, C3 === D3.

%* ===================== Sanshoku Doujun (Three Colored Sequences) =====================
yaku(sanshokuDoujun, victoria(Formas, _, _), _) :- 
    % probamos todas las numeraciones de escaleras posibles. 
    between(1, 7, NumeroInicioEscaleras),
    NumeroMedioEscaleras is NumeroInicioEscaleras + 1,
    NumeroFinEscaleras is NumeroMedioEscaleras + 1,
    NumerosEscaleras = [NumeroInicioEscaleras, NumeroMedioEscaleras, NumeroFinEscaleras],
    
    % buscamos a ver si tenemos una escalera en esos numeros para cada palo:
    escaleraDeNumerosYPalo(Formas, NumerosEscaleras, man),
    escaleraDeNumerosYPalo(Formas, NumerosEscaleras, pin),
    escaleraDeNumerosYPalo(Formas, NumerosEscaleras, sou).

%* ===================== Ittsuu (Pure Straight) =====================
yaku(ittsuu, victoria(Formas, _, _), _) :- 
    % probamos todos los palos donde podríamos tener un ittsuu. 
    member(Palo, [man,pin,sou]),

    % buscamos a ver si tenemos las tres escaleras en este palo:
    escaleraDeNumerosYPalo(Formas, [1,2,3], Palo),
    escaleraDeNumerosYPalo(Formas, [4,5,6], Palo),
    escaleraDeNumerosYPalo(Formas, [7,8,9], Palo).

%* ===================== Tanyao (All Simples) =====================
yaku(tanyao, victoria(Formas, _, _), _) :- 
    todasLasFichas(Formas, Fichas),
    \+ (member(F, Fichas), \+ simple(F)).

%* ===================== Bakazehai (Prevalent Wind - Yakuhai) =====================
yaku(bakazehai, victoria(Formas, _, _), situacion(VientoRonda, _, _)) :- 
    member(PiernaVientoRonda, Formas),
    pierna(PiernaVientoRonda), % es una pierna (tripla o quad),
    PiernaVientoRonda =.. [_, FichaPiernaVientoRonda | _],
    vientoCorrespondiente(FichaPiernaVientoRonda, VientoRonda). % está compuesto de las fichas del viento prevalente.

%* ===================== Jikazehai (Round Wind - Yakuhai) =====================
yaku(jikazehai, victoria(Formas, _, _), situacion(_, VientoJugador, _)) :- 
    member(PiernaVientoJugador, Formas),
    pierna(PiernaVientoJugador), % es una pierna (tripla o quad),
    PiernaVientoJugador =.. [_, FichaPiernaVientoJugador | _],
    vientoCorrespondiente(FichaPiernaVientoJugador, VientoJugador). % está compuesto de las fichas del viento del jugador.

%* ===================== Sangenpai (Dragon - Yakuhai) =====================
yaku(chun, victoria(Formas, _, _), _) :- 
    member(PiernaDragonRojo, Formas),
    pierna(PiernaDragonRojo), % es una pierna (tripla o quad),
    PiernaDragonRojo =.. [_, r | _]. % está compuesto de dragones rojos
yaku(hatsu, victoria(Formas, _, _), _) :- 
    member(PiernaDragonVerde, Formas),
    pierna(PiernaDragonVerde), % es una pierna (tripla o quad),
    PiernaDragonVerde =.. [_, g | _]. % está compuesto de dragones verdes
yaku(haku, victoria(Formas, _, _), _) :- 
    member(PiernaDragonBlanco, Formas),
    pierna(PiernaDragonBlanco), % es una pierna (tripla o quad),
    PiernaDragonBlanco =.. [_, wh | _]. % está compuesto de dragones blancos

%* ===================== Menzen Tsumo (Fully Concealed Hand) =====================
yaku(menzenTsumo, victoria(Formas, _, tsumo), _) :- 
    manoCerrada(Formas).

%* ===================== Shousangen (Little Three Dragons) =====================
yaku(shousangen, victoria(Formas, _, _), _) :- 
    % tenemos un par de dragones:
    select(ParDragon, Formas, FormasSin1),
    par(ParDragon),
    ParDragon =.. [_, FichaParDragon | _],
    dragon(FichaParDragon),
    % tenemos una pierna (tripla/quad) de dragones:
    select(PiernaDragonA, FormasSin1, FormasSin2),
    pierna(PiernaDragonA),
    PiernaDragonA =.. [_, FichaPiernaDragonA | _],
    dragon(FichaPiernaDragonA),
    % tenemos otra pierna (tripla/quad) de dragones:
    member(PiernaDragonB, FormasSin2),
    pierna(PiernaDragonB),
    PiernaDragonB =.. [_, FichaPiernaDragonB | _],
    dragon(FichaPiernaDragonB).

%* ===================== Daisangen (Big Three Dragons) =====================
yaku(daisangen, victoria(Formas, _, _), _) :- 
    % tenemos una primera pierna (tripla/quad) de dragones:
    select(PiernaDragonA, Formas, FormasSin1),
    pierna(PiernaDragonA),
    PiernaDragonA =.. [_, FichaPiernaDragonA | _],
    dragon(FichaPiernaDragonA),
    % tenemos una segunda pierna (tripla/quad) de dragones:
    select(PiernaDragonB, FormasSin1, FormasSin2),
    pierna(PiernaDragonB),
    PiernaDragonB =.. [_, FichaPiernaDragonB | _],
    dragon(FichaPiernaDragonB),
    % tenemos una tercera pierna (tripla/quad) de dragones:
    member(PiernaDragonC, FormasSin2),
    pierna(PiernaDragonC),
    PiernaDragonC =.. [_, FichaPiernaDragonC | _],
    dragon(FichaPiernaDragonC).

%* ===================== Shousuushii (Little Four Winds) =====================
yaku(shousuushii, victoria(Formas, _, _), _) :- 
    % tenemos un par de viento:
    select(ParViento, Formas, FormasSin1),
    par(ParViento),
    ParViento =.. [_, FichaParViento | _],
    viento(FichaParViento),
    % tenemos una primera pierna (tripla/quad) de viento:
    select(PiernaVientoA, FormasSin1, FormasSin2),
    pierna(PiernaVientoA),
    PiernaVientoA =.. [_, FichaPiernaVientoA | _],
    viento(FichaPiernaVientoA),
    % tenemos una segunda pierna (tripla/quad) de viento:
    select(PiernaVientoB, FormasSin2, FormasSin3),
    pierna(PiernaVientoB),
    PiernaVientoB =.. [_, FichaPiernaVientoB | _],
    viento(FichaPiernaVientoB),
    % tenemos una tercera pierna (tripla/quad) de viento:
    member(PiernaVientoC, FormasSin3),
    pierna(PiernaVientoC),
    PiernaVientoC =.. [_, FichaPiernaVientoC | _],
    viento(FichaPiernaVientoC).

%* ===================== Daisuushii (Big Four Winds) =====================
yaku(daisuushii, victoria(Formas, _, _), _) :- 
    % tenemos una primera pierna (tripla/quad) de viento:
    select(PiernaVientoA, Formas, FormasSin1),
    pierna(PiernaVientoA),
    PiernaVientoA =.. [_, FichaPiernaVientoA | _],
    viento(FichaPiernaVientoA),
    % tenemos una segunda pierna (tripla/quad) de viento:
    select(PiernaVientoB, FormasSin1, FormasSin2),
    pierna(PiernaVientoB),
    PiernaVientoB =.. [_, FichaPiernaVientoB | _],
    viento(FichaPiernaVientoB),
    % tenemos una tercera pierna (tripla/quad) de viento:
    select(PiernaVientoC, FormasSin2, FormasSin3),
    pierna(PiernaVientoC),
    PiernaVientoC =.. [_, FichaPiernaVientoC | _],
    viento(FichaPiernaVientoC),
    % tenemos una cuarta pierna (tripla/quad) de viento:
    member(PiernaVientoD, FormasSin3),
    pierna(PiernaVientoD),
    PiernaVientoD =.. [_, FichaPiernaVientoD | _],
    viento(FichaPiernaVientoD).

%* ===================== Chanta (Terminals & Honors Everywhere) =====================
yaku(chanta, victoria(Formas, _, _), _) :- 
    maplist(algunaFichaCumple(noSimple), Formas).

%* ===================== Junchan (Terminals Everywhere) =====================
yaku(junchan, victoria(Formas, _, _), _) :- 
    maplist(algunaFichaCumple(terminal), Formas).

%* ===================== Honroutou (All Terminals & Honors) =====================
yaku(honroutou, victoria(Formas, _, _), _) :- 
    maplist(todaFichaCumple(noSimple), Formas).

%* ===================== Chinroutou (All Terminals) =====================
yaku(chinroutou, victoria(Formas, _, _), _) :- 
    maplist(todaFichaCumple(terminal), Formas).

%* ===================== Tsuuiisou (All Honors) =====================
yaku(tsuuiisou, victoria(Formas, _, _), _) :- 
    maplist(todaFichaCumple(honor), Formas).

%* ===================== Auxiliares =====================
%! manoCerrada(+Formas) is semidet.
%* Relaciona manos (definida como una lista de Formas que la componen)
%* que estén cerradas; es decir, no hayan realizado llamadas.
%* Recordar que ganar por ron no anula una mano cerrada.
manoCerrada(Formas) :- \+ (member(Forma, Formas), llamada(Forma)).


%! yaku(+Formas, +Numeros, +Palo) is semidet.
%* Relaciona listas de Formas que tengan alguna escalera (abierta o cerrada)
%* de los números y el palo indicado
escaleraDeNumerosYPalo(Formas, Numeros, Palo) :-
    member(Escalera, Formas),
    escalera(Escalera), % es escalera
    fichasDeForma(Escalera, FichasEscalera),
    maplist(numero, FichasEscalera, Numeros), % va en el rango numérico indicado
    FichasEscalera = [FichaEscalera|_],
    palo(FichaEscalera, Palo). % es del palo indicado

%! algunaFichaCumple(+Predicado, +Forma) is nondet.
%* Predicado de alto orden que relaciona formas que tengan al menos una ficha
%* que cumpla el predicado.
algunaFichaCumple(PredicadoSobreFicha, Forma) :-
    forma(Forma),
    Forma =.. [_ | Fichas],
    member(Ficha, Fichas),
    call(PredicadoSobreFicha, Ficha),
    !.

%! todaFichaCumple(+Predicado, +Forma) is nondet.
%* Predicado de alto orden que relaciona formas cuyas fichas
%* cumplan todas el predicado,
todaFichaCumple(PredicadoSobreFicha, Forma) :-
    forma(Forma),
    Forma =.. [_ | Fichas],
    maplist(PredicadoSobreFicha, Fichas).