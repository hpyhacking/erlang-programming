-module(dist).
-export([t/1]).

t(From) ->
  From ! node().
