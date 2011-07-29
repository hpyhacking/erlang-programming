-module(usr).
-export([start/1, start/0, stop/0, init/2]).
-export([add_usr/3, delete_usr/1, set_service/3, set_status/2, delete_disabled/0, lookup_id/1]).
-export([lookup_msisdn/1, service_flag/2]).

-include("usr.hrl").
-define(TIMEOUT, 30000).

start() ->
  start("UsrTabFile").

start(FileName) ->
  register(?MODULE, spawn(?MODULE, init, [FileName, self()])),
  receive started -> ok after ?TIMEOUT -> {error, starting} end.

stop() ->
  call(stop).

add_usr(PhoneNum, CustId, Plan) when Plan == prepayl; Plan == postpay ->
  call({add_usr, PhoneNum, CustId, Plan}).

delete_usr(CustId) ->
  call({delete_usr, CustId}).

set_service(CustId, Service, Flag) when Flag == true; Flag == false ->
  call({set_service, CustId, Service, Flag}).

set_status(CustId, Status) when Status == enabled; Status == disabled ->
  call({set_status, CustId, Status}).

delete_disabled() ->
  call(delete_disabled).

lookup_id(CustId) ->
  usr_db:lookup_id(CustId).

lookup_msisdn(PhoneNo) ->
  usr_db:lookup_msisdn(PhoneNo).

service_flag(PhoneNo, Service) ->
  case usr_db:lookup_msisdn(PhoneNo) of
    {ok, #usr{services = Services, status = enabled}} ->
      lists:member(Service, Services);
    {ok, #usr{status=disabled}} ->
      {error, disabled};
    {error, Reason} ->
      {error, Reason}
  end.

call(Request) ->
  Ref = make_ref(),
  ?MODULE ! {request, {self(), Ref}, Request},
  receive
    {reply, Ref, Reply} -> Reply
  after
    ?TIMEOUT -> {error, timeout}
  end.

reply({From, Ref}, Reply) ->
  From ! {reply, Ref, Reply}.

init(FileName, Pid) ->
  usr_db:create_tables(FileName),
  usr_db:restore_backup(),
  Pid ! started,
  loop().

loop() ->
  receive
    {request, From, stop} ->
      reply(From, usr_db:close_tables());
    {request, From, Request} ->
      Reply = request(Request),
      reply(From, Reply),
      loop()
  end.

request({add_usr, PhoneNo, CustId, Plan}) ->
  usr_db:add_usr(
    #usr{
      msisdn=PhoneNo, 
      id=CustId, 
      plan=Plan
    }
  );

request({delete_usr, CustId}) ->
  usr_db:delete_usr(CustId);

request({set_service, CustId, Service, Flag}) ->
  case usr_db:lookup_id(CustId) of
    {ok, Usr} ->
      Services = lists:delete(Service, Usr#usr.services),
      NewServices = case Flag of
        true -> [Service | Services];
        false -> Services
      end,
      usr_db:update_usr(Usr#usr{services = NewServices});
    {error, instance} ->
      {error, instance}
  end;

request({set_status, CustId, Status}) ->
  case usr_db:lookup_id(CustId) of
    {ok, Usr} ->
      usr_db:update_usr(Usr#usr{status = Status});
    {error, instance} ->
      {error, instance}
  end;

request({delete_disabled}) ->
  usr_db:delete_disabled().
