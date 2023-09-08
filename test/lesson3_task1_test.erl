-module(lesson3_task1_test).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

first_word_test_() ->
    [?_assertException(error, function_clause, lesson3_task1:first_word([])),
     ?_assert(lesson3_task1:first_word(<<"Some Text">>) =:= <<"Some">>),
     ?_assert(lesson3_task1:first_word(<<"Some">>) =:= <<"Some">>)].

-endif.
