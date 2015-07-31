defmodule Excoap.Message do
  defstruct ver: 1, type: nil, code: nil, mid: 0, token: <<>>, options: [], payload: <<>>

  def decode(packet) do
    <<ver :: size(2), t :: size(2), tkl :: size(4), code :: binary - size(1), mid :: size(16), data :: binary>> = packet
    <<tok :: binary - size(tkl), data :: binary>> = data
    {opts, payload} = decode([], 0, data)
    %Excoap.Message{
      ver: ver,
      type: Excoap.Type.decode(t),
      code: Excoap.Code.decode(code),
      mid: mid,
      token: tok,
      options: Enum.reverse(opts),
      payload: payload
    }
  end

  defp decode(opts, _delta, <<>>) do
    {opts, <<>>}
  end

  defp decode(opts, _delta, <<0xFF, payload :: binary>>) do
    {opts, payload}
  end

  defp decode(opts, _delta, <<del :: size(4), len :: size(4), rest :: binary>>) do
    {delta, rest} = Excoap.Option.delta(del, rest)
    {length, rest} = Excoap.Option.length(len, rest)
    {value, rest} = Excoap.Option.value(length, rest)
    num = _delta + delta
    name = Excoap.Option.name(num)
    decode([{name, value} | opts], num, rest)
  end

  def encode(msg = %Excoap.Message{}) do
    <<msg.ver :: size(2), Excoap.Type.encode(msg.type) :: size(2), byte_size(msg.token) :: size(4)>> <> Excoap.Code.encode(msg.code) <> <<msg.mid :: size(16)>> <> msg.token <> encode_options(msg.options, 0) <> encode_payload(msg.payload)
  end

  defp encode_options([], _) do
    <<>>
  end

  defp encode_options([{name, value} | tail], delta) do
    {opt, d} = Excoap.Option.encode(name, value, delta)
    opt <> encode_options(tail, d)
  end

  defp encode_payload(<<>>) do
    <<>>
  end

  defp encode_payload(payload) do
    <<0xFF>> <> payload
  end
end
