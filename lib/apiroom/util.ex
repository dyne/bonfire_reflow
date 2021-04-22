defmodule Zenpub.Apiroom.Util do
  def maybe_put(map, _key, nil), do: map
  def maybe_put(map, key, val), do: Map.put(map, key, val)
end
