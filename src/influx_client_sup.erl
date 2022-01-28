%% Copyright (c) 2020-2022 Exograd SAS.
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
%% SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
%% IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(influx_client_sup).

-behaviour(c_sup).

-export([start_link/0, start_client/2]).
-export([children/0]).

-spec start_link() -> c_sup:start_ret().
start_link() ->
  c_sup:start_link({local, ?MODULE}, ?MODULE, #{}).

-spec start_client(influx:client_id(), influx_client:options()) ->
        c_sup:result(pid()).
start_client(Id, Options) ->
  Spec = #{start => fun influx_client:start_link/2,
           start_args => [Id, Options]},
  c_sup:start_child(?MODULE, Id, Spec).

-spec children() -> c_sup:child_specs().
children() ->
  ClientSpecs0 = application:get_env(influx, clients, #{}),
  ClientSpecs =
    case maps:is_key(default, ClientSpecs0) of
      true ->
        ClientSpecs0;
      false ->
        ClientSpecs0#{default => #{}}
    end,
  maps:fold(fun (Id, Options, Acc) ->
                Spec = #{start => fun influx_client:start_link/2,
                         start_args => [Id, Options]},
                [{Id, Spec} | Acc]
            end, [], ClientSpecs).
