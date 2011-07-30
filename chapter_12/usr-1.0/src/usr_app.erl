-module(usr_app).
-behavior(application).

-export([start/2, stop/1]).

start(_Type, StartArgs) ->
  usr_sup:start_link().

stop(_State) ->
  ok.
