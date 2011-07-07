-module(myring).
-export([start/1, start_proc/2]).

start(Num) ->
	start_proc(Num, self()).

start_proc(0, Pid) ->
	Pid ! ok;

start_proc(Num, Pid) ->
	NPid = spawn(myring, start_proc, [Num-1, Pid]),
	NPid ! ok,
	receive ok -> ok end.
