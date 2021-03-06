defmodule Bonfire.Reflow.EconomicProcesses do
  import Bonfire.Common.Config, only: [repo: 0]

  alias Bonfire.Reflow.Data.Signed
  alias ValueFlows.Process.Processes

  def create(creator, attrs) do
    with {:ok, process} <- Processes.create(creator, attrs),
         {:ok, signature} <- Bonfire.Reflow.sign(process),
         {:ok, _} <- Bonfire.Reflow.verify(signature) do
      repo().update(Signed.changeset(signature))
    end
  end
end
