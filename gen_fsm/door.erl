-module(door).
-export([start/1, init/1]).

start(Codes) ->
  spawn(fun() -> door:init(Codes) end).

init(Codes) ->
  init_lock(Codes),
  loop().

init_lock([]) ->
  ok;

init_lock([Code|Codes]) ->
  Res = code_lock:start_link(Code),
  io:format("Result is ~p~n", [Res]),
  init_lock(Codes).

loop() ->
  receive
    ok -> 
      {ok},
      loop()
  end.
