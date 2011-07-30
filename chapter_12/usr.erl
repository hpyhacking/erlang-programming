-module(usr).
-export([start_link/0, start_link/1, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([add_usr/3, delete_usr/1, set_service/3, set_status/2, delete_disabled/0, lookup_id/1]).
-export([lookup_msisdn/1, service_flag/2]).

-behavior(gen_server).

-include("usr.hrl").
-define(TIMEOUT, 30000).

start_link() ->
  {ok, FileName} = application:get_env(dets_name),
  start_link(FileName).

start_link(FileName) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, FileName, []).

stop() ->
  gen_server:cast(?MODULE, stop).

init(FileName) ->
  usr_db:create_tables(FileName),
  usr_db:restore_backup(),
  {ok, null}.

terminate(Reason, LoopData) ->
  usr_db:close_tables().

add_usr(PhoneNum, CustId, Plan) when Plan == prepay; Plan == postpay ->
  gen_server:call(?MODULE, {add_usr, PhoneNum, CustId, Plan}).

delete_usr(CustId) ->
  gen_server:call(?MODULE, {delete_usr, CustId}).

set_service(CustId, Service, Flag) when Flag == true; Flag == false ->
  gen_server:call(?MODULE, {set_service, CustId, Service, Flag}).

set_status(CustId, Status) when Status == enabled; Status == disabled ->
  gen_server:call(?MODULE, {set_status, CustId, Status}).

delete_disabled() ->
  gen_server:call(?MODULE, delete_disabled).

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

handle_call({add_usr, PhoneNo, CustId, Plan}, _From, LoopData) ->
  Reply = usr_db:add_usr(
    #usr{
      msisdn=PhoneNo, 
      id=CustId, 
      plan=Plan
    }
  ),
  {reply, Reply, LoopData};

handle_call({delete_usr, CustId}, _From, LoopData) ->
  Reply = usr_db:delete_usr(CustId),
  {reply, Reply, LoopData};

handle_call({set_service, CustId, Service, Flag}, _From, LoopData) ->
  Reply = case usr_db:lookup_id(CustId) of
    {ok, Usr} ->
      Services = lists:delete(Service, Usr#usr.services),
      NewServices = case Flag of
        true -> [Service | Services];
        false -> Services
      end,
      usr_db:update_usr(Usr#usr{services = NewServices});
    {error, instance} ->
      {error, instance}
  end,
  {reply, Reply, LoopData};

handle_call({set_status, CustId, Status}, _From, LoopData) ->
  Reply = case usr_db:lookup_id(CustId) of
    {ok, Usr} ->
      usr_db:update_usr(Usr#usr{status = Status});
    {error, instance} ->
      {error, instance}
  end,
  {reply, Reply, LoopData};

handle_call({delete_disabled}, _From, LoopData) ->
  Reply = usr_db:delete_disabled(),
  {reply, Reply, LoopData}.

handle_cast(stop, LoopData) ->
  {stop, normal, LoopData}.

handle_info(Msg, LoopData) ->
  io:format("Recive Not OPT Message ~p~n", [Msg]),
  {noreply, LoopData}.
