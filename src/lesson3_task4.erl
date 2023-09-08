-module(lesson3_task4).

-export([decode/2, getTestJson/0]).

decode(Json, Type) ->
    decodeNest(Json, Type).

decodeNest(Json, map) ->
    decodeNest(Json, [start], map);
decodeNest(Json, proplist) ->
    decodeNest(Json, [start], proplist);
decodeNest(_, Type) ->
    throw(lists:flatten(
              io_lib:format(<<"No case clause matching: ~p. Try to use map or proplist">>, [Type]))).

% ----------------------------------------START------------------------------
decodeNest(<<"{", T/binary>>, [start | _] = _State, map) ->
    decodeNest(T, [{object, #{}}], map);
decodeNest(<<"{", T/binary>>, [start | _] = _State, Result) ->
    decodeNest(T, [{object, []}], Result);
decodeNest(<<"[", T/binary>>, [start | _] = _State, Result) ->
    decodeNest(T, [{array, []}], Result);
% ----------------------------------------OBJECT------------------------------
decodeNest(<<":", T/binary>>, [{object, _} | _] = State, Result) ->
    decodeNest(T, [{waitValue, <<>>} | State], Result);
decodeNest(<<"}", T/binary>>, [{object, Res}] = State, map) ->
    decodeNest(T, State, Res);
decodeNest(<<"}", T/binary>>, [{object, Res}] = State, _Result) ->
    decodeNest(T, State, lesson3_task2:reverse(Res));
decodeNest(<<"}", T/binary>>, [{object, Res}, {object, [{Key} | Object]} | Tail] = _State, map) ->
    decodeNest(T, [{object, maps:put(Key, Res, Object)} | Tail], map);
decodeNest(<<"}", T/binary>>, [{object, Res}, {object, [{Key} | Object]} | Tail] = _State, Result) ->
    decodeNest(T, [{object, [{Key, lesson3_task2:reverse(Res)} | Object]} | Tail], Result);
decodeNest(<<"}", T/binary>>, [{object, Res}, {array, Array} | Tail] = _State, map) ->
    decodeNest(T, [{array, [Res | Array]} | Tail], map);
decodeNest(<<"}", T/binary>>, [{object, Res}, {array, Array} | Tail] = _State, Result) ->
    decodeNest(T, [{array, [lesson3_task2:reverse(Res) | Array]} | Tail], Result);
% ----------------------------------------ARRAY------------------------------
decodeNest(<<",", T/binary>>, [{array, _} | _] = State, Result) ->
    decodeNest(T, [{waitValue, <<>>} | State], Result);
decodeNest(<<"]", T/binary>>, [{array, Res}] = State, _Result) ->
    decodeNest(T, State, lesson3_task2:reverse(Res));
decodeNest(<<"]", T/binary>>, [{array, Res}, {object, [{Key} | Object]} | Tail] = _State, map) ->
    decodeNest(T, [{object, maps:put(Key, Res, Object)} | Tail], map);
decodeNest(<<"]", T/binary>>, [{array, Res}, {object, [{Key} | Object]} | Tail] = _State, Result) ->
    decodeNest(T, [{object, [{Key, lesson3_task2:reverse(Res)} | Object]} | Tail], Result);
decodeNest(<<"]", T/binary>>, [{array, Res}, {array, Array} | Tail] = _State, Result) ->
    decodeNest(T, [{array, [lesson3_task2:reverse(Res) | Array]} | Tail], Result);
% -------------------------------------KEY------------------------------------
decodeNest(<<"'", T/binary>>, [{object, _} | _] = State, Result) ->
    decodeNest(T, [{key, <<>>} | State], Result);
decodeNest(<<"'", T/binary>>, [{key, Name}, {object, Val} | Tail], Result) ->
    decodeNest(T, [{object, [{Name} | Val]} | Tail], Result);
decodeNest(<<Symbol/utf8, T/binary>>, [{key, Name} | Tail], Result) ->
    decodeNest(T, [{key, <<Name/binary, Symbol/utf8>>} | Tail], Result);
%------------------------------------Value---------------------------------------
decodeNest(<<"'", T/binary>>, [{waitValue, _} | Tail] = _State, Result) ->
    decodeNest(T, [{value, <<>>} | Tail], Result);
decodeNest(<<"true", T/binary>>, [{waitValue, _} | Tail], Result) ->
    decodeNest(<<"'", T/binary>>, [{value, true} | Tail], Result);
decodeNest(<<"false", T/binary>>, [{waitValue, _} | Tail], Result) ->
    decodeNest(<<"'", T/binary>>, [{value, false} | Tail], Result);
decodeNest(<<"{", T/binary>>, [{waitValue, _} | Tail], map) ->
    decodeNest(T, [{object, #{}} | Tail], map);
decodeNest(<<"{", T/binary>>, [{waitValue, _} | Tail], Result) ->
    decodeNest(T, [{object, []} | Tail], Result);
decodeNest(<<"[", T/binary>>, [{waitValue, _} | Tail] = _State, Result) ->
    decodeNest(T, [{waitValue, <<>>}, {array, []} | Tail], Result);
decodeNest(<<"-", T/binary>>, [{waitValue, _} | Tail], Result) ->
    decodeNest(T, [{valueNumber, <<"-">>, integer} | Tail], Result);
decodeNest(<<Symbol/utf8, T/binary>>, [{waitValue, _} | Tail], Result) when Symbol >= 48 andalso Symbol < 58 ->
    decodeNest(T, [{valueNumber, <<Symbol/utf8>>, integer} | Tail], Result);
decodeNest(<<"true", T/binary>>, [{array, Array} | Tail] = _State, Result) ->
    decodeNest(T, [{array, [true | Array]} | Tail], Result);
decodeNest(<<"false", T/binary>>, [{array, Array} | Tail] = _State, Result) ->
    decodeNest(T, [{array, [false | Array]} | Tail], Result);
decodeNest(<<"'", T/binary>>, [{value, Value}, {array, Array} | Tail] = _State, Result) ->
    decodeNest(T, [{array, [Value | Array]} | Tail], Result);
decodeNest(<<"'", T/binary>>, [{value, Value}, {object, [{Key} | Object]} | Tail] = _State, map) ->
    decodeNest(T, [{object, maps:put(Key, Value, Object)} | Tail], map);
decodeNest(<<"'", T/binary>>, [{value, Value}, {object, [{Key} | Object]} | Tail] = _State, Result) ->
    decodeNest(T, [{object, [{Key, Value} | Object]} | Tail], Result);
decodeNest(<<Symbol/utf8, T/binary>>, [{valueNumber, Value, Type} | Tail], Result) when Symbol >= 48 andalso Symbol < 58 ->
    decodeNest(T, [{valueNumber, <<Value/binary, Symbol/utf8>>, Type} | Tail], Result);
decodeNest(<<Symbol/utf8, T/binary>>, [{valueNumber, Value, _Type} | Tail], Result) when Symbol =:= 46 ->
    decodeNest(T, [{valueNumber, <<Value/binary, Symbol/utf8>>, float} | Tail], Result);
decodeNest(<<Symbol/utf8, T/binary>>, [{value, Value} | Tail], Result) ->
    decodeNest(T, [{value, <<Value/binary, Symbol/utf8>>} | Tail], Result);
decodeNest(<<Symbol/utf8, T/binary>>, [{valueNumber, Value, Type} | Tail], Result) ->
    ValueFormated =
        case Type of
            float ->
                binary_to_float(Value);
            _ ->
                binary_to_integer(Value)
        end,
    decodeNest(<<"'", Symbol/utf8, T/binary>>, [{value, ValueFormated} | Tail], Result);
% --------------------------------------OTHER-----------------------------------------------------
decodeNest(<<_/utf8, T/binary>>, State, Result) ->
    decodeNest(T, State, Result);
% --------------------------------------FINISH---------------------------------------------------
decodeNest(<<>>, _State, Result) ->
    Result.

getTestJson() ->
    <<"
{
'squadName': 'Super hero squad',
'homeTown': 'Metro City',
'formed': -2016,
'secretBase': 'Super tower',
'active': true,
'members': [
{
'name': 'Molecule Man',
'age': 29.5,
'secretIdentity': 'Dan Jukes',
'powers': [
'Radiation resistance',
'Turning tiny',
'Radiation blast'
]
},
{
'name': 'Madame Uppercut',
'age': 39,
'secretIdentity': 'Jane Wilson',
'powers': [
'Million tonne punch',
'Damage resistance',
'Superhuman reflexes'
]
},
{
'name': 'Eternal Flame',
'age': 1000000,
'secretIdentity': 'Unknown',
'powers': [
'Immortality',
'Heat Immunity',
'Inferno',
'Teleportation',
'Interdimensional travel', true
]
}
]
}
">>.

% ,<<"{'key1': 'value1', 'key2': 'value2'}">>
% ,<<"{'key1': 2016, 'key2': 'value2'}">>
% ,<<"[true, false]">>
% ,<<"{'key1': 'value1', 'keyObj': {'keyInObj': 'valueInObj', 'keyInObj2': true},'key2': 'value2'}">>
% ,<<"{'key1': true, 'key3': 12.1, 'keyArr': ['valueInArr1', 'valueInArr2', true, false],'key2': false, 'key4': 12.1}">>
% ,<<"{'key1': true, 'key3': 12.1, 'keyArr': [{'k1': 'v1', 'k2': 'v2'}],'key2': false, 'key4': 12.1}">>
