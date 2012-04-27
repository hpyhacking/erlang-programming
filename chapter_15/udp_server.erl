-module(udp_server).
-export([start_link/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([send/1]).

-behaviour(gen_server).

-define(SERVER_PORT, 18000).
-define(CLIENT_PORT, 18001).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, null, []).

stop() ->
  gen_server:cast(?MODULE, stop).

init(_Params) ->
  {ok, Sock} = gen_udp:open(?SERVER_PORT),
  io:format("Init Sock ~p~n", [Sock]),
  {ok, {server, Sock}}.

terminate(Reason, {server, Sock}) ->
  gen_udp:close(Sock).

handle_cast(stop, {server, Sock}) ->
  {stop, normal, {server, Sock}}.

handle_info({udp, Client, _Ip, _Port, Msg}, LoopData) ->
  io:format("receive udp data ~p from ~p~n", [Msg, Client]),
  {noreply, LoopData};

handle_info(Msg, LoopData) ->
  io:format("receive info ~p~n", [Msg]),
  {noreply, LoopData}.
  
send(Msg) ->
  gen_server:call(?MODULE, {message, Msg}).

handle_call({message, Msg}, _From, {server, Sock}) ->
  {ok, Client} = gen_udp:open(?CLIENT_PORT),
  io:format("Sock ~p Client ~p~n", [Sock, Client]),
  gen_udp:send(Client, {127,0,0,1}, ?SERVER_PORT, Msg),
  gen_udp:close(Client),
  {reply, ok, {server, Sock}}.
