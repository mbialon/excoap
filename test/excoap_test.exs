defmodule ExcoapTest do
  use ExUnit.Case

  test "decode con get without token, options, and payload" do
    msg = Excoap.decode <<1 :: size(2), 0 :: size(2), 0 :: size(4), 1 :: size(8), 279 :: size(16)>>
    assert msg == %Excoap.Message{ver: 1, type: :con, code: :get, mid: 279, token: <<>>, options: [], payload: <<>>}
  end

  test "decode non post with payload" do
    msg = Excoap.decode <<1 :: size(2), 1 :: size(2), 0 :: size(4), 2 :: size(8), 123 :: size(16), 0xFF, 1, 2, 3, 4>>
    assert msg == %Excoap.Message{ver: 1, type: :non, code: :post, mid: 123, token: <<>>, options: [], payload: <<1, 2, 3, 4>>}
  end

  test "decode ack with token" do
    msg = Excoap.decode <<1 :: size(2), 2 :: size(2), 4 :: size(4), 2 :: size(3), 1 :: size(5), 42 :: size(16), 0xAB, 0xCD, 0xEF, 0x42>>
    assert msg == %Excoap.Message{ver: 1, type: :ack, code: :created, mid: 42, token: <<0xAB, 0xCD, 0xEF, 0x42>>, options: [], payload: <<>>}
  end

  test "encode request" do
    msg = %Excoap.Message{ver: 1, type: :con, code: :get, mid: 42, token: <<0xAB, 0xCD, 0xEF, 0x42>>, options: [], payload: <<>>}
    packet = Excoap.encode(msg)
    assert packet == <<1 :: size(2), 0 :: size(2), 4 :: size(4), 0 :: size(3), 1 :: size(5), 42 :: size(16), 0xAB, 0xCD, 0xEF, 0x42>>
  end

  test "encode request with options" do
    msg = %Excoap.Message{type: :con, code: :get, options: [{:uri_path, "sensor"}, {:uri_path, "temp"}]}
    packet = Excoap.encode(msg)
    assert packet == <<1 :: size(2), 0 :: size(2), 0 :: size(4), 0 :: size(3), 1 :: size(5), 0 :: size(16), 11 :: size(4), 6 :: size(4), "sensor", 0 :: size(4), 4 :: size(4), "temp">>
  end

  test "encode request with long option" do
    msg = %Excoap.Message{type: :con, code: :get, options: [{:proxy_uri, "loremipsumloremipsumloremipsum"}]}
    packet = Excoap.encode(msg)
    assert packet == <<1 :: size(2), 0 :: size(2), 0 :: size(4), 0 :: size(3), 1 :: size(5), 0 :: size(16), 13 :: size(4), 13 :: size(4), 22 :: size(8), 17 :: size(8), "loremipsumloremipsumloremipsum">>
  end

  test "encode response" do
    msg = %Excoap.Message{ver: 1, type: :ack, code: :created, mid: 42, token: <<0xAB, 0xCD, 0xEF, 0x42>>, options: [], payload: <<0x11, 0x22, 0x33>>}
    packet = Excoap.encode(msg)
    assert packet == <<1 :: size(2), 2 :: size(2), 4 :: size(4), 2 :: size(3), 1 :: size(5), 42 :: size(16), 0xAB, 0xCD, 0xEF, 0x42, 0xFF, 0x11, 0x22, 0x33>>
  end

  test "encode and decode" do
    msg1 = %Excoap.Message{type: :con, code: :get, options: [{:uri_path, "sensor"}, {:uri_path, "temp"}]}
    msg2 = Excoap.encode(msg1) |> Excoap.decode
    assert msg1 == msg2
  end
end
