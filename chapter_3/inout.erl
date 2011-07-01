-module(inout).
-export([get_chars/0, get_line/0, read/0]).

get_chars() ->
  io:get_chars("tell me > ", 2).

get_line() ->
  io:get_line("tell line > ").

read() ->
  io:read("tell read > ").
