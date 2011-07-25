%%% File: usr.hrl
%%% Description: Include file for user db

-record(usr, {msisdn,
              id,
              status = enabled,
              plan,
              services = []}).
