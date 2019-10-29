% Instituto Tecnologico de Costa Rica
% Lenguajes de Programacion
% Tarea Programada 3 -
% Paradigma Logico - Prolog
% Natan Fernandez de Castro - 2017105774
% Kevin Rojas Salazar - 2016081582

% ======================================
% |            Ejercicio 1             |
% ======================================
% Ejercicio que tiene como proposito implementar
% un grafo dirigido para una empresa distribuidora
% de comida y buscar la ruta mas corta para entregas
%
% --------------------------------------
% [ Hechos ]
% --------------------------------------

:-dynamic
	rpath/2.      % A reversed path

% Hechos que manejan la relacion de peso y comision
% dos nodos
edge(a,b,10,5).
edge(b,c,3,1).
edge(b,e,5,2).
edge(b,d,4,2).
edge(e,h,2,1).
edge(d,h,1,0.5).
edge(c,f,2,1).
edge(f,i,3,2).
edge(f,j,3,2).
edge(g,j,1,0.5).
edge(h,f,1,0.5).
edge(h,i,6,3).


% Algoritmo de ruta mas corta Dijsktra el cual suma comisiones
% Al encontrar el camino mas corto

path(From,To,Dist,Com) :- edge(To,From,Dist,Com).
path(From,To,Dist,Com) :- edge(From,To,Dist,Com).

shorterPath([H|Path], Dist,Com) :-		       %Camino menor al camino almacenado
	rpath([H|T], D,C), !, Dist < D, Com < C,          % Hace emparejamiento
	retract(rpath([H|_],_,_)),
	writef('%w is closer than %w\n', [[H|Path], [H|T]]),
	assert(rpath([H|Path], Dist,Com)).
shorterPath(Path, Dist,Com) :-		       % Almacenamiento
	writef('New path:%w\n', [Path]),
	assert(rpath(Path,Dist,Com)).

traverse(From, Path, Dist,Com) :-		    % Todos los nodos alcsnzables
	path(From, T, D,C),		    % Para cada vecino
	not(memberchk(T, Path)),	                  % no visitado
	shorterPath([T,From|Path], Dist+D,Com+C), %	Actualiza el nuevo camino y la distancia
	traverse(T,[From|Path],Dist+D,Com+C).	    %El vecino

traverse(From) :-
	retractall(rpath(_,_,_)),           % Remueve soluciones
	traverse(From,[],0,0).              % Origen
traverse(_).

% -------------------------------------------------------------
% Funcion principal del algoritmo, se encarga de capturar
% los nodos origen y destino y llama a las funciones encargadas
% de calcular la ruta mas corta
% Entradas: Nodo Origen y Nodo Destino ej: go(X,Y).
% Salidas: Impresion en pantalla de ruta mas corta del nodo origen y
%           destino y la suma de las comisiones
% Restricciones: Nodos existentes en los hechos
% ------------------------------------------------------------
go(From, To) :-
	traverse(From),                   % Encuentra todas las distancias
	rpath([To|RPath], Dist,Com)->     % Una vez encontrada la distancia final
	  reverse([To|RPath], Path),      % Procede a fijar esa distancia
	  Distance is round(Dist),		  % Asigna la variable dist a Distancia y la redondea
	  Comision is round(Com),         % Asigna la variable Com a Comision y la redondea

	  %Imprime en pantalla el resultado
	  writef('El camino mas corto es %w con distancia %w = %w y comision %w = %w\n',
	       [Path, Dist, Distance,Com,Comision]);

	% Caso contrario de no exito imprime que no logro encontrar la ruta mas
	% corta
	writef('No hay ruta de %w a %w\n', [From, To]).

