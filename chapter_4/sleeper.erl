-module(sleeper).
-export([send/3, sleep/1]).

send(Pid, Time, Msg) ->
	receive
	after
		Time ->
			Pid ! Msg
	end.

sleep(T) ->
	receive
	after
		T -> true
	end.
