-module(mfmn_entity_state).

-export([
	 new/0,
	 set/2
	]).

new() ->
    <<"">>.

set(New, _Old) ->
    New.
