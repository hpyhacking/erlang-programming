-module(list).
-compile(export_all).

filter([], _N) -> [];
filter([H|T], N) when H =< N -> [H | filter(T, N)];
filter([_H|T], N) -> filter(T, N).

reverse(List) -> reverse(List, []).

% Good Job 要多使用尾递归
reverse([], R) -> R;
reverse([H|T], R) -> reverse(T, [H|R]).

concatenate([], R) -> reverse(R);
concatenate([[]|Ty], R) -> concatenate(Ty, R);
concatenate([[H|Tx]|Ty], R) -> concatenate([Tx|Ty], [H|R]).

