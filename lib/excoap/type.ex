defmodule Excoap.Type do
	def decode(0) do :con end
	def decode(1) do :non end
	def decode(2) do :ack end
	def decode(3) do :rst end
end
