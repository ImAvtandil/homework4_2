-module(lesson3_task2).

-export([words/1, reverse/1]).

words(String) ->
    reverse(words(String, <<>>, [])).

words(<<S/utf8, 32, T/binary>>, AccBin, Acc) ->
    words(T, <<>>, [<<AccBin/binary, S/utf8>> | Acc]);
words(<<S/utf8, T/binary>>, AccBin, Acc) ->
    words(T, <<AccBin/binary, S/utf8>>, Acc);
words(<<>>, AccBin, Acc) ->
    [AccBin | Acc].

reverse(List) ->
    reverse(List, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
