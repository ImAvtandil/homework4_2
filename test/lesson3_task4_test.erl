-module(lesson3_task4_test).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

decode_test_() ->
    [?_assert(lesson3_task4:decode(<<"[true, true, false]">>, proplist) =:= [true, true, false]),
     ?_assert(lesson3_task4:decode(<<"{'key1': 'value1', 'keyObj': {'keyInObj': 'valueInObj', 'keyInObj2': true},'key2': 'value2'}">>,
                                   proplist)
              =:= [{<<"key1">>, <<"value1">>},
                   {<<"keyObj">>, [{<<"keyInObj">>, <<"valueInObj">>}, {<<"keyInObj2">>, true}]},
                   {<<"key2">>, <<"value2">>}]),
     ?_assert(lesson3_task4:decode(<<"{'key1': 'value1', 'keyObj': {'keyInObj': 'valueInObj', 'keyInObj2': true},'key2': 'value2'}">>,
                                   map)
              =:= #{<<"key1">> => <<"value1">>,
                    <<"key2">> => <<"value2">>,
                    <<"keyObj">> => #{<<"keyInObj">> => <<"valueInObj">>, <<"keyInObj2">> => true}}),
     ?_assert(lesson3_task4:decode(<<"[true, true, false]">>, map) =:= [true, true, false]),
     ?_assert(lesson3_task4:decode(
                  lesson3_task4:getJsonReal(), map)
              =:= lesson3_task4:getResMap()),
     ?_assert(lesson3_task4:decode(
                  lesson3_task4:getJsonReal(), proplist)
              =:= lesson3_task4:getResProplist())].

-endif.
