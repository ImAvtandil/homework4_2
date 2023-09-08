-module(lesson3_task3_test).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

split_test_() ->
    [?_assert(lesson3_task3:split(<<"Some Text">>, " ") =:= [<<"Some">>, <<"Text">>]),
     ?_assert(lesson3_task3:split(<<"Some Text  DubleSpace">>, " ") =:= [<<"Some">>, <<"Text">>, <<" DubleSpace">>]),
     ?_assert(lesson3_task3:split(<<"Some">>, " ") =:= [<<"Some">>]),
     ?_assert(lesson3_task3:split(<<"COL1-:-COL2-:-COL3">>, "-:-") =:= [<<"COL1">>, <<"COL2">>, <<"COL3">>]),
     ?_assert(lesson3_task3:split(<<"COL1|COL2|COL3|COL4">>, "|") =:= [<<"COL1">>, <<"COL2">>, <<"COL3">>, <<"COL4">>])].

-endif.
