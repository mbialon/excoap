defmodule Excoap.Type do
  def decode(t) do
    case t do
      0 -> :con
      1 -> :non
      2 -> :ack
      3 -> :rst
    end
  end

  def encode(t) do
    case t do
      :con -> 0
      :non -> 1
      :ack -> 2
      :rst -> 3
    end
  end
end
