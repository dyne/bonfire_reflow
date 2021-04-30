defmodule Bonfire.Reflow.Hooks.VFProcessHook do
  @moduledoc """
  Hook to be used after the creation/update of a valueflows process.
  """

  use Bonfire.Common.Hooks.Hook

  alias ValueFlows.Process.Processes

  def do_after({Processes, :create}, process) do
    with {:ok, input_events} <- Processes.inputs(process),
         {:ok, signed} <- Bonfire.Reflow.aggregate(input_events) do
      # TODO: store in signed mixin
      {:error, :unimplemented}
    end
  end
end
