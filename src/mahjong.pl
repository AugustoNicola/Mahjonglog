%* ===================== punto de entrada =====================
%* Carga los archivos que componen el proyecto:
%*   fichas.pl              - definición de fichas e igualdad entre ellas
%*   juegos.pl               - pares, triplas y escaleras
%*   orden.pl                - orden estándar de fichas
%*   llamadas.pl             - chii, pon, kanAbierto y kanCerrado
%*   forma_mano_ganadora.pl  - condiciones de mano ganadora
%*   victoria.pl             - evento de ganar una mano
%*   situacion.pl            - estado de la partida al momento de ganar
%*   yakus.pl                - condiciones de cada yaku

:- ensure_loaded(fichas).
:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(llamadas).
:- ensure_loaded(forma_mano_ganadora).
:- ensure_loaded(victoria).
:- ensure_loaded(situacion).
:- ensure_loaded(yakus).
