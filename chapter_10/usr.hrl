%%% File: usr.hrl
%%% Description: Include file for user db

-type(plan()    :: prepay | postpay).
-type(status()  :: enabled | disabled).
-type(service() :: atom()).

-record(usr, 
  {
    msisdn              ::integer(),
    id                  ::integer(),
    status = enabled    ::status(),
    plan                ::plan(),
    services = []       ::[service()]
  }
).
