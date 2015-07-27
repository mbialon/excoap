defmodule Excoap do
  def decode(msg) do
		Excoap.Decoder.decode(msg)
	end
end
