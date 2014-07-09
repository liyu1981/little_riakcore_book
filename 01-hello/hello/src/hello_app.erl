-module(hello_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  case hello_sup:start_link() of
    {ok, Pid} ->
      ok = riak_core:register([{vnode_module, hello_vnode}]),
      ok = riak_core_node_watcher:service_up(hello, self()),
      {ok, Pid};
    {error, Reason} ->
      {error, Reason}
  end.

stop(_State) ->
  ok.
