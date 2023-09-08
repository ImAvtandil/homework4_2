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
                  lesson3_task4:getTestJson(), map)
              =:= #{<<"active">> => true,
                    <<"formed">> => -2016,
                    <<"homeTown">> => <<"Metro City">>,
                    <<"members">> =>
                        [#{<<"age">> => 1000000,
                           <<"name">> => <<"Eternal Flame">>,
                           <<"powers">> =>
                               [true, <<"Interdimensional travel">>, <<"Teleportation">>, <<"Inferno">>, <<"Heat Immunity">>, <<"Immortality">>],
                           <<"secretIdentity">> => <<"Unknown">>},
                         #{<<"age">> => 39,
                           <<"name">> => <<"Madame Uppercut">>,
                           <<"powers">> => [<<"Superhuman reflexes">>, <<"Damage resistance">>, <<"Million tonne punch">>],
                           <<"secretIdentity">> => <<"Jane Wilson">>},
                         #{<<"age">> => 29.5,
                           <<"name">> => <<"Molecule Man">>,
                           <<"powers">> => [<<"Radiation blast">>, <<"Turning tiny">>, <<"Radiation resistance">>],
                           <<"secretIdentity">> => <<"Dan Jukes">>}],
                    <<"secretBase">> => <<"Super tower">>,
                    <<"squadName">> => <<"Super hero squad">>}),
     ?_assert(lesson3_task4:decode(
                  lesson3_task4:getTestJson(), proplist)
              =:= [{<<"squadName">>, <<"Super hero squad">>},
                   {<<"homeTown">>, <<"Metro City">>},
                   {<<"formed">>, -2016},
                   {<<"secretBase">>, <<"Super tower">>},
                   {<<"active">>, true},
                   {<<"members">>,
                    [[{<<"name">>, <<"Molecule Man">>},
                      {<<"age">>, 29.5},
                      {<<"secretIdentity">>, <<"Dan Jukes">>},
                      {<<"powers">>, [<<"Radiation resistance">>, <<"Turning tiny">>, <<"Radiation blast">>]}],
                     [{<<"name">>, <<"Madame Uppercut">>},
                      {<<"age">>, 39},
                      {<<"secretIdentity">>, <<"Jane Wilson">>},
                      {<<"powers">>, [<<"Million tonne punch">>, <<"Damage resistance">>, <<"Superhuman reflexes">>]}],
                     [{<<"name">>, <<"Eternal Flame">>},
                      {<<"age">>, 1000000},
                      {<<"secretIdentity">>, <<"Unknown">>},
                      {<<"powers">>,
                       [<<"Immortality">>, <<"Heat Immunity">>, <<"Inferno">>, <<"Teleportation">>, <<"Interdimensional travel">>, true]}]]}])].

-endif.
