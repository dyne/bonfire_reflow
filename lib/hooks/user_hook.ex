defmodule Bonfire.Reflow.Hooks.UserHook do
  @moduledoc """
  Hook to be used after the creation/update of a user to generate a
  public key.
  """

  use Bonfire.Common.Hooks.Hook

  alias Bonfire.Data.Identity.User

  def do_after({_, :create}, %User{} = user) do
  end
end
