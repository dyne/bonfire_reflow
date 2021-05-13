defmodule Bonfire.Reflow.Users do
  import Bonfire.Common.Config, only: [repo: 0]

  alias Bonfire.Reflow.Data.SignedUser
  alias Bonfire.Me.Users

  def create(attrs, extras \\ nil) do
    with {:ok, user} <- Users.create(attrs, extras),
         {:ok, public_key} <- Bonfire.Reflow.agent_public_key(user) do
      repo().update(SignedUser.changeset(public_key))
    end
  end
end
