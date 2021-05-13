defmodule Bonfire.Reflow do
  alias Bonfire.Reflow.Apiroom

  def agent_public_key(agent) do
  end

  def sign(data, keys \\ nil) do
    Apiroom.signatures(data, keys)
  end

  def verify(data, keys \\ nil) do
  end

  def aggregate(data, keys \\ nil) do
  end
end
