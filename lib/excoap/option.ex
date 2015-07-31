defmodule Excoap.Option do
	def delta(13, <<delta :: size(8), rest :: binary>>) do
		{delta + 13, rest}
	end

	def delta(14, <<delta :: size(16), rest :: binary>>) do
		{delta + 269, rest}
	end

	def delta(delta, data) do
		{delta, data}
	end

	def length(13, <<length :: size(8), rest :: binary>>) do
		{length + 13, rest}
	end

	def length(14, <<length :: size(16), rest :: binary>>) do
		{length + 269, rest}
	end

	def length(length, data) do
		{length, data}
	end

	def value(length, data) do
		<<value :: binary - size(length), rest :: binary>> = data
		{value, rest}
	end

  def encode(name, value, delta) do
    d = Excoap.Option.number(name) - delta
    len = byte_size(value)
    {<<
    encode_delta(d) :: size(4),
    encode_length(len) :: size(4),
    encode_delta_ext(d) :: binary,
    encode_length_ext(len) :: binary,
    value :: binary>>, delta + d}
  end

  defp encode_delta(delta) do
    cond do
      delta > 255 -> 14
      delta > 12  -> 13
      true        -> delta
    end
  end

  defp encode_delta_ext(delta) do
    cond do
      delta > 255 -> <<delta - 269 :: size(16)>>
      delta > 12  -> <<delta - 13 :: size(8)>>
      true        -> <<>>
    end
  end

  defp encode_length(length) do
    cond do
      length > 255 -> 14
      length > 12  -> 13
      true         -> length
    end
  end

  defp encode_length_ext(length) do
    cond do
      length > 255 -> <<length - 269 :: size(16)>>
      length > 12  -> <<length - 13 :: size(8)>>
      true         -> <<>>
    end
  end

  def number(name) do
    case name do
			:if_match -> 1
			:uri_host -> 3
			:etag -> 4
			:if_none_match -> 5
			:uri_port -> 7
			:location_path -> 8
			:uri_path -> 11
			:content_format -> 12
			:max_age -> 14
			:uri_query -> 15
			:accept -> 17
			:location_query -> 20
			:proxy_uri -> 35
			:proxy_scheme -> 39
			:size1 -> 60
		end
  end

	def name(num) do
		case num do
			1  -> :if_match
			3  -> :uri_host
			4  -> :etag
			5  -> :if_none_match
			7  -> :uri_port
			8  -> :location_path
			11 -> :uri_path
			12 -> :content_format
			14 -> :max_age
			15 -> :uri_query
			17 -> :accept
			20 -> :location_query
			35 -> :proxy_uri
			39 -> :proxy_scheme
			60 -> :size1
		end
	end
end
