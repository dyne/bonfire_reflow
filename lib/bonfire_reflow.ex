defmodule Bonfire.Reflow do
  alias Bonfire.Reflow.Apiroom

  def sign(data, keys \\ nil) do
    Apiroom.signatures(data, keys)
  end

  def verify(data, keys \\ nil) do
  end

  def aggregate(data, keys \\ nil) do
  end
end
