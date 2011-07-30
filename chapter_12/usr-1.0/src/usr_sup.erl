-module(usr_sup).
-behavior(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, null).

init(_) ->
  UsrChild = {
    usr, {usr, start_link, []},
    permanent, 2000, worker, [usr, usr_db]},

  {ok, {{one_for_all, 2, 2}, [UsrChild]}}.

