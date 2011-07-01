-module(guard).
-export([factorial/1]).

factorial(N) when N > 0 ->
  N * factorial(N-1);
factorial(0) -> 1.
