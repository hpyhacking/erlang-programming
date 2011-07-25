-module(pingpong).
-export([go/0, loop/0, stop/0]).

go() -> 
	register(echo, spawn_link(pingpong, loop, [])),
	echo ! {msg, self(), hello},

	receive
		{_Pid, Msg} ->
			io:format("receive a message ~w from ~w ~n", [Msg, _Pid])
	end.

stop() ->
  exit(self(), kill).

loop() ->
	receive
		{msg, From, Msg} ->
			io:format("receive a message ~w from ~w ~n", [Msg, From]),
			From ! {self(), Msg},
			loop();
		stop ->
			io:format("receive a stop ~n", []),
			true
	end.
		

