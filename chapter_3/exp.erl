-module(exp).
-compile(export_all).

% exp #1-1
sum(0) -> 0;
sum(Num) when Num =< 0 -> exit("Num > 0");
sum(Num) when Num > 0 -> Num + sum(Num - 1).

% exp #1-2
sum(N, M) when N > M -> exit("N > M");
sum(N, N) -> N;
sum(N, M) -> N + sum(N + 1, M).

% exp #2-1
create(0) -> [];
create(Count) -> create_ex(Count, 1).

create_ex(Count, Count) -> [Count];
create_ex(Count, Current) when Count > Current -> [Current | create_ex(Count, Current + 1)].

% exp #2-2
reverse_create(0) -> [];
reverse_create(Count) when Count > 0 -> [Count | reverse_create(Count - 1)].

% exp #3-1
print(0) -> io:format("Number:~p~n", [0]);
print(Count) -> print_ex(Count, 1).

print_ex(Count, Count) -> io:format("Number:~p~n", [Count]);

print_ex(Count, Current) when Count > Current -> 
  io:format("Number:~p~n", [Current]),
  print_ex(Count, Current + 1).


print_rem(Count) when Count > 0 -> print_rem_ex(Count, 1).

print_rem_ex(Count, Count) when Count rem 2 == 0 -> io:format("Number:~p~n", [Count]);
print_rem_ex(Count, Count) -> return; 
print_rem_ex(Count, Current) when Current rem 2 == 0 -> io:format("Number:~p~n", [Current]), print_rem_ex(Count, Current + 1);
print_rem_ex(Count, Current) -> print_rem_ex(Count, Current + 1).
