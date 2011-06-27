-module(def).
-export([convert/1, convert_def/1]).

convert(Day) ->
  case Day of
    monday -> 1;
    tuesday -> 2;
    wednesday -> 3;
    thursday -> 4;
    friday -> 5;
    staturday -> 6;
    sunday -> 7
end.

% 8> def:convert(amonday).
% ** exception error: no case clause matching amonday
%    in function  def:convert/1

convert_def(Day) ->
  case Day of
    monday -> 1;
    tuesday -> 2;
    wednesday -> 3;
    thursday -> 4;
    friday -> 5;
    staturday -> 6;
    sunday -> 7;
    Other -> {error, unknown_day}
end.

% 2> c(def).
% ./def.erl:13: Warning: variable 'Other' is unused
% {ok,def}
% 3> def:convert(sunday). 
% 7
% 4> def:convert(other). 
% {error,unknown_day}

