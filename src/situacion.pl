%* ===================== Situación de la partida =====================
%* Modela el estado de juego en el momento de la victoria, independiente
%* de las fichas de la mano (a diferencia de victoria/3, ver victoria.pl).

%! situacion(?VientoRonda, ?VientoJugador, ?Flags) is det.
%* VientoRonda, VientoJugador in {este, sur, oeste, norte}.
%* Flags es una lista de atomos que describen eventos de la ronda
%* (riichi, ippatsu, doble_riichi, houtei, haitei, rinshan, chankan, ...).

%! tieneFlag(+Situacion, +Flag) is semidet.
%* Indica si Flag está presente en los flags de Situacion.
tieneFlag(situacion(_, _, Flags), Flag) :- memberchk(Flag, Flags).

%* ===================== Validación =====================

%! vientoValido(?Viento) is nondet.
vientoValido(este). vientoValido(sur). vientoValido(oeste). vientoValido(norte).

%! flagSoportado(?Flag) is nondet.
%* Subconjunto inicial de flags reconocidos; se puede ampliar a medida
%* que se implementen más yakus que dependan de la situación.
flagSoportado(riichi).
flagSoportado(doble_riichi).
flagSoportado(ippatsu).
flagSoportado(houtei).
flagSoportado(haitei).
flagSoportado(rinshan).
flagSoportado(chankan).

%! flagsIncompatibles(?Flag1, ?Flag2) is nondet.
%* Pares de flags que no pueden darse juntos en una misma situación.
%* No hace falta declarar ambos órdenes: flagsCompatibles/1 los prueba en los dos sentidos.
flagsIncompatibles(riichi, doble_riichi).      % riichi y doble riichi son excluyentes: es uno u otro
flagsIncompatibles(houtei, haitei).            % houtei (último descarte) y haitei (último robo) son excluyentes
flagsIncompatibles(houtei, rinshan).           % houtei (descarte) y rinshan (robo tras kan) son excluyentes
flagsIncompatibles(chankan, rinshan).          % chankan (robar un kan ajeno) y rinshan (kan propio) son excluyentes
flagsIncompatibles(chankan, haitei).           % chankan es sobre un descarte disfrazado de kan, no un robo propio

%! situacionValida(+Situacion) is semidet.
%* Corrobora que Situacion tenga vientos válidos, que todos sus flags
%* sean reconocidos y que no haya combinaciones de flags incompatibles
%* entre sí (ver flagsIncompatibles/2), ni ippatsu sin riichi.
situacionValida(situacion(VientoRonda, VientoJugador, Flags)) :-
    vientoValido(VientoRonda),
    vientoValido(VientoJugador),
    forall(member(Flag, Flags), flagSoportado(Flag)),
    \+ (flagsIncompatibles(F1, F2), memberchk(F1, Flags), memberchk(F2, Flags)),
    \+ (memberchk(ippatsu, Flags), \+ memberchk(riichi, Flags), \+ memberchk(doble_riichi, Flags)).
