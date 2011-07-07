-module(echo).
-export([go/0, loop/0]).

go() -> 
	register(echo, spawn(echo, loop, [])),
	echo ! {self(), hello},

	receive
		{_Pid, Msg} ->
			io:format("receive a message ~w from ~w ~n", [Msg, _Pid])
	end.

loop() ->
	receive
		{From, Msg} ->
			io:format("receive a message ~w from ~w ~n", [Msg, From]),
			From ! {self(), Msg},
			loop();
		stop ->
			io:format("receive a stop ~n", []),
			true
	end.
		

