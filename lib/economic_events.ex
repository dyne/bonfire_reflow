defmodule Bonfire.Reflow.EconomicEvents do
  import Bonfire.Common.Config, only: [repo: 0]

  alias Bonfire.Reflow.Data.Signed
  alias ValueFlows.EconomicEvent.EconomicEvents

  def create(creator, attrs, extra_attrs \\ %{}) do
    with {:ok, event} <- EconomicEvents.create(creator, attrs, extra_attrs),
         {:ok, signature} <- Bonfire.Reflow.sign(event),
         {:ok, _} <- Bonfire.Reflow.verify(signature) do
      repo().update(Signed.changeset(signature))
    end
  end
end
