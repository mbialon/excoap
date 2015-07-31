defmodule Excoap do
  def decode(packet) do
    Excoap.Message.decode(packet)
	end

  def encode(msg) do
    Excoap.Message.encode(msg)
  end
end
