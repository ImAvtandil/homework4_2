-module(lesson3_task2_test).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

words_test_() ->
    [?_assertException(error, function_clause, lesson3_task2:words([])),
     ?_assert(lesson3_task2:words(<<"Some Text">>) =:= [<<"Some">>, <<"Text">>]),
     ?_assert(lesson3_task2:words(<<"Some Text  DubleSpace">>) =:= [<<"Some">>, <<"Text">>, <<"DubleSpace">>]),
     ?_assert(lesson3_task2:words(<<"Some">>) =:= [<<"Some">>])].

-endif.
