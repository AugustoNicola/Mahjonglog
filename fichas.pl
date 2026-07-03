:- module(fichas, [mostrar/1, style/2]).

style(m1,"🀇"). style(m2,"🀈"). style(m3,"🀉"). style(m4,"🀊"). style(m5,"🀋").
style(m5R,"🀋"). style(m6,"🀌"). style(m7,"🀍"). style(m8,"🀎"). style(m9,"🀏").

style(p1,"🀙"). style(p2,"🀚"). style(p3,"🀛"). style(p4,"🀜"). style(p5,"🀝").
style(p5R,"🀝"). style(p6,"🀞"). style(p7,"🀟"). style(p8,"🀠"). style(p9,"🀡").

style(s1,"🀐"). style(s2,"🀑"). style(s3,"🀒"). style(s4,"🀓"). style(s5,"🀔").
style(s5R,"🀔"). style(s6,"🀕"). style(s7,"🀖"). style(s8,"🀗"). style(s9,"🀘").

style(e,"🀀"). style(s,"🀁"). style(w,"🀂"). style(n,"🀃").
style(r,"🀄"). style(g,"🀅"). style(wh,"🀆").

style(back, "🀫").

ansi_color(reset,   "\e[0m").
ansi_color(rojo,    "\e[1;31m"). 
ansi_color(verde,   "\e[1;32m").
ansi_color(azul,    "\e[1;34m").
ansi_color(blanco,  "\e[1;37m"). 

color(F, rojo)   :- palo(F, man), !.
color(F, verde)  :- palo(F, sou), !.
color(F, azul)   :- palo(F, pin), !.
color(F, azul)   :- palo(F, viento), !.

color(r, rojo)   :- !.
color(g, verde)  :- !.
color(wh, blanco):- !.
color(back, blanco).

color(s5R, rojo) :- !.
color(m5R, rojo) :- !.
color(p5R, rojo) :- !.


mostrar(F) :-
    style(F, S),
    color(F, ColorNombre),
    ansi_color(ColorNombre, ColorCodigo),
    ansi_color(reset, ResetCode),
    format('~w~w~w', [ColorCodigo, S, ResetCode]).

