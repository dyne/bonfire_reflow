defmodule Bonfire.Reflow do
  alias Bonfire.Reflow.Apiroom

  def agent_public_key(agent, keys \\ nil) do
    Apiroom.fetch("/agent", agent, keys)
  end

  def sign(data, keys \\ nil) do
    Apiroom.fetch("/signatures", data, keys)
  end

  def verify(data, keys \\ nil) do
    Apiroom.fetch("/verify", data, keys)
  end

  def aggregate(data, keys \\ nil) do
    Apiroom.fetch("/aggregate", data, keys)
  end
end
