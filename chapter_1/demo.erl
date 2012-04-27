-module(demo).
-export([double/1, area/1]).

double(Value) -> 
  times(Value, 2).

times(X, Y) -> X * Y.

area(sharp) -> {sharp, 1};
area(Other) -> {sharp, Other}.
