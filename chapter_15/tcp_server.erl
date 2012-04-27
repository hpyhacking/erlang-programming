-module(tcp_server).
-export([start/0, send/2]).

-define(log(Message),
  fun() -> 
      io:foramt("<~p> LOGGER: ~p~n", [self(), Message])
  end()).

start() ->
  {ok, ListenSocket} = gen_tcp:listen(5000, [binary, {active, false}]),
  wait_connect(ListenSocket, 0).

wait_connect(ListenSocket, Count) ->
  ?log("Begin Wait Connection ...").
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  ?log("Receive a TCP request ...").
