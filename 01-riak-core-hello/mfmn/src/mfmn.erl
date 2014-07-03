-module(mfmn).
-include("mfmn.hrl").
-include_lib("riak_core/include/riak_core_vnode.hrl").

-export([
         ping/0,
         get/1,
         set/2,
         list/0
        ]).

-ignore_xref([
              ping/0,
              get/1,
              set/2,
              list/0
             ]).

%% Public API

%% @doc Pings a random vnode to make sure communication is functional
ping() ->
  DocIdx = riak_core_util:chash_key({<<"ping">>, term_to_binary(now())}),
  PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, mfmn),
  [{IndexNode, _Type}] = PrefList,
  riak_core_vnode_master:sync_spawn_command(IndexNode, ping, mfmn_vnode_master).

get(Key) ->
  mfmn_entity_read_fsm:start(
    {
     mfmn_vnode,
     mfmn
    },
    get, Key
   ).

list() ->
  mfmn_entity_coverage_fsm:start(
    {
     mfmn_vnode,
     mfmn
    },
    list
   ).


set(Key, Value) ->
  mfmn_entity_write_fsm:write(
    {
     mfmn_vnode,
     mfmn
    }, Key, set, Value).
