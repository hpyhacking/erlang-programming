-module(ring).
-export([loop/1, new_proc/1, new_proc/3]).

new_proc(N) when N > 1 ->
  FirstPid = spawn(ring, loop, [self()]),
  new_proc(N - 1, FirstPid, FirstPid).

new_proc(0, Pid, FirstPid) ->
  FirstPid ! {loop, Pid},
  register(ring_srv, FirstPid),
  io:format("Successful create processes");

new_proc(N, Pid, FirstPid) -> 
  NewPid = spawn(ring, loop, [Pid]),
  new_proc(N - 1, NewPid, FirstPid).



loop(Pid) -> 
  receive 
    {loop, LastPid} ->
      loop(LastPid);

    {message, 1} -> 
      io:format("~w receive a last message ~n", [self()]),
      loop(Pid);

    {message, Count} ->
      io:format("~w receive a message ~w -> send ~w to ~w ~n", [self(), Count, Count - 1, Pid]),
      Pid ! {message, Count - 1},
      loop(Pid)
  end.
