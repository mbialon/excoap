defmodule Excoap.Server do
  def start(port \\ 0, handler) do
    pid = spawn_link(fn ->
      open!(port) |> handle(handler)
    end)
    {:ok, pid}
  end

  def start!(port \\ 0, handler) do
    {:ok, pid} = start(port, handler)
    pid
  end

  defp open!(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary])
    socket
  end

  defp handle(socket, handler) do
    receive do
      {:udp, socket, ip_addr, port, packet} ->
        msg = Excoap.Message.decode(packet)
        send(handler, {self(), ip_addr, port, msg})
        handle(socket, handler)
      {:excoap, ip_addr, port, msg} ->
        packet = Excoap.Message.encode(msg)
        :ok = :gen_udp.send(socket, ip_addr, port, packet)
        handle(socket, handler)
    end
  end

  def register(pid, ip_addr, port, id) do
    ep = :io_lib.format("ep=~32.16.0B", [id]) |> List.to_string
    msg = %Excoap.Message{
      type: :con,
      code: :post,
      options: [
        {:uri_path, "rd"},
        {:uri_query, ep}
      ]
    }
    send(pid, {:excoap, ip_addr, port, msg})
  end
end
