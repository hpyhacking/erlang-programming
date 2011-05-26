-module(every).
-export([add_one/1, avg/1, even/1, member/2, sum_acc/2, bump/2]).

add_one([]) -> [];
add_one([H|T]) -> [H + 1 | add_one(T)].

%bump([], List) -> reverse(List);
bump([H|T], List) -> bump(T, [H+1|List]).

avg(List) -> sum(List) / len(List).

sum([])    -> 0;
sum([H|T]) -> H + sum(T).

len([])    -> 0;
len([_|T]) -> 1 + len(T).

even([]) -> [];
even([Head | Tail]) when Head rem 2 == 0 -> [Head | even(Tail)];
even([_ | Tail]) -> even(Tail).

member(_, []) -> false;
member(Item, [H|_]) when Item == H -> true;
member(Item, [_|T]) -> member(Item, T).

sum_acc([], Sum) -> Sum;
sum_acc([H|T], Sum) -> sum_acc(T, Sum + H).
