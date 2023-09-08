-module(lesson3_task3).

-export([split/2]).

split(String, Delimiter) ->
    DelimiterBin = erlang:list_to_bitstring(Delimiter),
    DelimiterSize = erlang:byte_size(DelimiterBin),
    lesson3_task2:reverse(split(String, DelimiterBin, DelimiterSize, <<>>, [])).

split(<<_/utf8, _/binary>> = String, Delimiter, DelimiterSize, StrAcc, Acc) ->
    {Tail, StrAcc2, Acc2} =
        case String of
            <<A/utf8, D:DelimiterSize/binary, T/binary>> when D == Delimiter ->
                {T, <<>>, [<<StrAcc/binary, A/utf8>> | Acc]};
            <<A/utf8, T/binary>> ->
                {T, <<StrAcc/binary, A/utf8>>, Acc}
        end,
    split(Tail, Delimiter, DelimiterSize, StrAcc2, Acc2);
split(<<>>, _, _, StrAcc, Acc) ->
    [StrAcc | Acc].
