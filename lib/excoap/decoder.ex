defmodule Excoap.Decoder do
	def decode(packet) do
		<<ver :: size(2), t :: size(2), tkl :: size(4), code :: binary - size(1), mid :: size(16), data :: binary>> = packet
		<<tok :: binary - size(tkl), data :: binary>> = data
		{opts, payload} = decode([], 0, data)
		{ver, Excoap.Type.decode(t), Excoap.Code.decode(code), mid, {:token, tok}, Enum.reverse(opts), payload}
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
end
