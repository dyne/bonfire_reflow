defmodule Bonfire.Reflow.Hooks.VFEventHook do
  @moduledoc """
  Hook to be used after the creation/update of a valueflows event.
  """

  use Bonfire.Common.Hooks.Hook

  def do_after({ValueFlows.EconomicEvent.EconomicEvents, :create}, event) do
    with {:ok, signed_event} <- Bonfire.Reflow.sign(event) do
      # TODO: store signature in Signed mixin
      {:error, :unimplemented}
    end
  end
end
