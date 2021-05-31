defmodule Bonfire.Reflow.Users do
  import Bonfire.Common.Config, only: [repo: 0]

  alias Bonfire.Reflow.Data.SignedUser
  alias Bonfire.Me.Users

  def create(attrs, extras \\ nil) do
    with {:ok, user} <- Users.create(attrs, extras),
         {:ok, credentials} <- Bonfire.Reflow.agent_credentials(user) do
      repo().update(SignedUser.changeset(credentials))
    end
  end
end
