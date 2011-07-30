{application, usr, [
    {description, "Mobile Services Database"},
    {vsn, "1.0"},
    {modules, [usr, usr_db, usr_sup, usr_app]},
    {registered, [usr, usr_sup]},
    {applications, [kernel, stdlib]},
    {env, [{dets_name, "usrDb.db"}]},
    {mod, {usr_app, []}}]}.
    
