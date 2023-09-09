-module(lesson3_task1).

-export([first_word/1]).

first_word(Bitstring) ->
    first_word(Bitstring, <<>>).

first_word(<<S/utf8, 32, _/binary>>, Acc) ->
    <<Acc/binary, S/utf8>>;
first_word(<<S/utf8, T/binary>>, Acc) ->
    first_word(T, <<Acc/binary, S/utf8>>);
first_word(<<>>, Acc) ->
    Acc.
