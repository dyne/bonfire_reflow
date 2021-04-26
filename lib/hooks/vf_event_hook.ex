defmodule Bonfire.Reflow.Hooks.VFEventHook do
  @moduledoc """
  Hook to be used after the creation/update of a valueflows event.
  """

  def do_after(event) do
    with {:ok, signed_event} <- Bonfire.Reflow.sign(event) do
      # TODO: store signature in Signed mixin
      {:error, :unimplemented}
    end
  end
end
