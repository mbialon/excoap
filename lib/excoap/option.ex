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
			_  -> num
		end
	end
end
