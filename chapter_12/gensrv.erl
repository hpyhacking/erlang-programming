-module(sample_gensrv).
-export([start/0, stop/0]).
-export([init/1, handle_cast/2, handle_call/3, terminate/2]).
-export([say_hello/1]).

-behavior(gen_server).

start() ->
  Name = "Jack",
  gen_server:start({local, ?MODULE}, ?MODULE, Name, []).

init(Name) ->
  io:format("Init OPT ~p~n", [Name]),
  {ok, null}.

say_hello(Name) ->
  NewName = gen_server:call(?MODULE, {say_hello, Name}),
  io:format("Hello ~p ~n", [NewName]).

stop() ->
  gen_server:cast(?MODULE, stop).

handle_cast(stop, LoopData) ->
  io:format("Stop OPT~n"),
  {stop, normal, LoopData}.

terminate(Reason, LoopData) ->
  io:format("Terminate OPT ~p ~p ~n", [Reason, LoopData]).

handle_call({say_hello, Name}, _From, LoopData) ->
  io:format("Hello ~p ~n", [Name]),
  {reply, "Tommy", LoopData}.


