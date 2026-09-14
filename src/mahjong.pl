%* ===================== punto de entrada =====================
%* Carga los archivos que componen el proyecto:
%*   fichas.pl              - definición de fichas e igualdad entre ellas
%*   juegos.pl               - pares, triplas y escaleras
%*   orden.pl                - orden estándar de fichas
%*   forma_mano_ganadora.pl  - condiciones de mano ganadora

:- ensure_loaded(fichas).
:- ensure_loaded(juegos).
:- ensure_loaded(orden).
:- ensure_loaded(forma_mano_ganadora).
