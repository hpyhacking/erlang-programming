-module(order_sup).
-behavior(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, {{one_for_one, 1, 1}, [
        {make_ref(), {gen_server, start_link, [server, ["Srv1", 2000], []]}, permanent, 1000, worker, [server]},
        {make_ref(), {gen_server, start_link, [server, ["Srv2", 3000], []]}, permanent, 1000, worker, [server]}
  ]}}.
