-module(server).
-behavior(gen_server).

-export([init/1, terminate/2, handle_call/3, handle_cast/2, code_change/3, handle_info/2]).

%%
%% Callback Functions
%%

init([Name, Time]) ->
  io:format("~w server start after ~w ms ~n", [Name, Time]),
  timer:sleep(Time),
  io:format("~w server start successful ~n", [Name]),
  {ok, nil}.

terminate(_Reason, _LoopData) ->
  ok.

handle_info(_Info, LoopData) ->
  {noreply, LoopData}.

code_change(_OldVsn, LoopData, _Extra) ->
  {ok, LoopData}.

handle_call(_Msg, _From, LoopData) ->
  {reply, ok, LoopData}.

handle_cast(stop, LoopData) ->
  {stop, normal, LoopData};
handle_cast(_Msg, LoopData) ->
  {noreply, LoopData}.

