defmodule Excoap.Code do
	def decode(<<class :: size(3), detail :: size(5)>>) do
		case {class, detail} do
			{0, 0} -> :empty
			{0, 1} -> :get
			{0, 2} -> :post
			{0, 3} -> :put
			{0, 4} -> :delete
			_      -> to_string(class, detail)
		end
	end

	defp to_string(c, d) do
		:io_lib.format("~b.~2..0b", [c, d]) |> to_string
	end
end
