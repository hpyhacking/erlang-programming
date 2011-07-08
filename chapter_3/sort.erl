-module(sort).
-compile(export_all).

quick([]) -> [];

quick([H|T]) -> 
  [Max, Min] = quick_x(H, T, [], []),
  flatten([quick(Max) | [H | quick(Min)]]).

quick_x(_, [], Min, Max) ->
  [Max, Min];

quick_x(Cur, [H|T], Min, Max) when Cur < H ->
  quick_x(Cur, T, Min, [H|Max]);

quick_x(Cur, [H|T], Min, Max) when Cur >= H ->
  quick_x(Cur, T, [H|Min], Max).

flatten([]) -> 
flatten([H|T]) ->
  [H|flatten(T)].
