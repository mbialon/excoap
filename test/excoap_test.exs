defmodule ExcoapTest do
  use ExUnit.Case

	test "decode con get without token, options, and payload" do
		msg = Excoap.decode <<1 :: size(2), 0 :: size(2), 0 :: size(4), 1 :: size(8), 279 :: size(16)>>
		assert msg == {1, :con, :get, 279, {:token, <<>>}, [], <<>>}
	end

	test "decode non post with payload" do
		msg = Excoap.decode <<1 :: size(2), 1 :: size(2), 0 :: size(4), 2 :: size(8), 123 :: size(16), 0xFF, 1, 2, 3, 4>>
		assert msg == {1, :non, :post, 123, {:token, <<>>}, [], <<1, 2, 3, 4>>}
	end

	test "decode ack with token" do
		msg = Excoap.decode <<1 :: size(2), 2 :: size(2), 4 :: size(4), 2 :: size(3), 0 :: size(5), 42 :: size(16), 0xAB, 0xCD, 0xEF, 0x42>>
		assert msg == {1, :ack, "2.00", 42, {:token, <<0xAB, 0xCD, 0xEF, 0x42>>}, [], <<>>}
	end
end
