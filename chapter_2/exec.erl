-module(exec).
-export([sum/1, sum/2, create/1]).

% 练习3-1 表达式求值
sum(1) -> 1;
sum(I) when I > 0 -> I + sum(I - 1);
sum(_) -> {error, "less one"}.

sum(N, M) when N > M -> exit("N > M");
sum(N, N)            -> N;
sum(N, M) -> N + sum(N + 1, M).

create(0) -> [];
create(C) when C > 0 -> [C | create(C - 1)].
