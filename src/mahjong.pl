%* ===================== punto de entrada =====================
%* Carga los archivos que componen el proyecto:
%*   fichas.pl               - definición de fichas e igualdad entre ellas
%*   juegos.pl               - pares, triplas y escaleras
%*   orden.pl                - orden estándar de fichas
%*   formas.pl               - pares, escaleras, triplas, quads y formas de mano
%*   forma_mano_ganadora.pl  - condiciones de mano ganadora
%*   victoria.pl             - evento de ganar una mano
%*   situacion.pl            - estado de la partida al momento de ganar
%*   yakus.pl                - condiciones de cada yaku

:- ensure_loaded(fichas).
:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(formas).
:- ensure_loaded(forma_mano_ganadora).
:- ensure_loaded(victoria).
:- ensure_loaded(situacion).
:- ensure_loaded(yakus).
