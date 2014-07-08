%% @doc Interface into the Real Time Statistics application.
-module(rts).
-include("rts.hrl").
-include_lib("riak_core/include/riak_core_vnode.hrl").

-export([ping/0,
         entry_from_file/2,
         entry/2,
         get/2,
         set/3,
         append/3,
         incr/2,
         incrby/3,
         sadd/3,
         get_dbg_preflist/2,
         get_dbg_preflist/3
        ]).

-define(TIMEOUT, 5000).

%%%===================================================================
%%% API
%%%===================================================================

% @doc Pings a random vnode to make sure communication is functional
ping() ->
  DocIdx = riak_core_util:chash_key({<<"ping">>, term_to_binary(now())}),
  PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, rts),
  [{IndexNode, _Type}] = PrefList,
  riak_core_vnode_master:sync_spawn_command(IndexNode, ping, rts_vnode_master).

% @doc Process entries from a file
entry_from_file(Client, FilePath) ->
  case file:read_file(FilePath) of
    {ok, Data} ->
      LinesData = binary:split(Data, [<<"\n">>], [global]),
      lists:foreach(fun(LineData) -> entry(Client, binary_to_list(LineData)) end, LinesData),
      io:format("~p entries processed~n", [length(LinesData)]),
      ok;
    {error, Reason} ->
      io:format("Read file ~s failed: ~p~n", [FilePath, Reason])
  end.

%% @doc Process an entry.
entry(Client, Entry) ->
  DocIdx = riak_core_util:chash_key({list_to_binary(Client), term_to_binary(now())}),
  PrefList = riak_core_apl:get_apl(DocIdx, 1, rts_entry),
  [IdxNode] = PrefList,
  rts_entry_vnode:entry(IdxNode, Client, Entry).

%% @doc Show the preflist.
get_dbg_preflist(Client, StatName) ->
  DocIdx = riak_core_util:chash_key({list_to_binary(Client), list_to_binary(StatName)}),
  riak_core_apl:get_apl(DocIdx, ?N, rts_stat).

%% @doc Get the value from Nth vnode of the preflist.
get_dbg_preflist(Client, StatName, N) ->
  IdxNode = lists:nth(N, get_dbg_preflist(Client, StatName)),
  {ok, req_id, Val} = riak_core_vnode_master:sync_command(IdxNode, {get, req_id, StatName}, rts_stat_vnode_master),
  [IdxNode, Val].

%% @doc Get a stat's value.
get(Client, StatName) ->
  {ok, ReqID} = rts_get_fsm:get(Client, StatName),
  wait_for_reqid(ReqID, ?TIMEOUT).

%% @doc Set a stat's value, replacing the current value.
set(Client, StatName, Val) ->
  {ok, ReqID} = rts_write_fsm:write(Client, StatName, set, Val),
  wait_for_reqid(ReqID, ?TIMEOUT).

%% @doc Append to a stat's value.
append(Client, StatName, Val) ->
  {ok, ReqID} = rts_write_fsm:write(Client, StatName, append, Val),
  wait_for_reqid(ReqID, ?TIMEOUT).

%% @doc Increment the stat's value by 1.
incr(Client, StatName) ->
  {ok, ReqID} = rts_write_fsm:write(Client, StatName, incr),
  wait_for_reqid(ReqID, ?TIMEOUT).

%% @doc Increment the stat's value by Val.
incrby(Client, StatName, Val) ->
  {ok, ReqID} = rts_write_fsm:write(Client, StatName, incrby, Val),
  wait_for_reqid(ReqID, ?TIMEOUT).

%% @doc Add a memeber to the stat's set.
sadd(Client, StatName, Val) ->
  {ok, ReqID} = rts_write_fsm:write(Client, StatName, sadd, Val),
  wait_for_reqid(ReqID, ?TIMEOUT).

%%%===================================================================
%%% Internal Functions
%%%===================================================================

wait_for_reqid(ReqID, Timeout) ->
  receive
    {ReqID, ok} -> ok;
    {ReqID, ok, Val} -> Val
  after Timeout ->
          {error, timeout}
  end.
