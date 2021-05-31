defmodule Bonfire.Reflow do
  alias Bonfire.Reflow.Apiroom

  def agent_credentials(%{character: %{username_hash: username}}, keys \\ nil) do
    reflow_agent = %{"AgentName" => username}

    with {:ok, %{^username => credential_request}} <- Apiroom.fetch("AgentCreate", reflow_agent, keys) do
      Apiroom.fetch("IssueCredential", credential_request, keys)
    end
  end

  def sign(data, keys \\ nil) do
    Apiroom.fetch("/signatures", data, keys)
  end

  def verify(data, keys \\ nil) do
    Apiroom.fetch("/verify", data, keys)
  end

  def aggregate(data, keys \\ nil) do
    Apiroom.fetch("/aggregate", data, keys)
  end
end
