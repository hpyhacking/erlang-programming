-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() -> [].
destroy(_Db) -> successful.

write(Key, Val, Db) -> [{Key, Val} | Db].

delete(_Key, []) -> [];
delete(Key, [{HK, _}|T]) when Key == HK -> delete(Key, T);
delete(Key, [H|T]) -> [H|delete(Key, T)].

read(_Key, []) -> {error, instance};
read(Key, [{H_Key, Val}|_T]) when Key == H_Key -> {ok, Val};
read(Key, [_H|T]) -> read(Key, T).

match(_Val, []) -> [];
match(Val, [{H_Key, H_Val} | T]) when H_Val == Val -> [H_Key | match(Val, T)];
match(Val, [_H|T]) -> match(Val, T).
