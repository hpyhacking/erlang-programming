-module(code_lock).
-behaviour(gen_fsm).

-export([start_link/1]).
-export([button/1]).
-export([init/1, locked/2, open/2]).

% client function
%
start_link(Code) ->
  gen_fsm:start({local, ?MODULE}, code_lock, Code, []).

button(Digit) ->
  gen_fsm:send_event(?MODULE, {button, Digit}).

% callback function
%
init(Code) ->
  io:format("new code lock ~p ~n", [Code]),
  {ok, locked, {[], Code}}.

locked({button, Digit}, {SoFar, Code}) ->
  case [Digit|SoFar] of
    Code ->
      % do_unlock(),
      io:format("do unlock"),
      {next_state, open, {[], Code}, 3000};
    Incomplete when length(Incomplete)<length(Code) ->
      {next_state, locked, {Incomplete, Code}};
    _Wrong ->
      {next_state, locked, {[], Code}}
  end.

open(timeout, State) ->
  io:format("do lock"),
  % do_lock(),
  {next_state, locked, State}.
