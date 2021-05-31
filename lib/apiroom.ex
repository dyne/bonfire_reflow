defmodule Bonfire.Reflow.Apiroom do
  import Bonfire.Common.Utils, only: [maybe_put: 3]

  @moduledoc """
  A Bonfire.Reflow/Bonfire extension for communicating with ZenRoom's APIRoom project.

  See https://apiroom.net
  """

  @default_http_client :hackney
  @request_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  @spec fetch(http_client :: atom, path :: binary, data :: map, keys :: map) :: {:ok, map} | {:error, term}
  def fetch(http_client, path, data, keys) do
    keys = if keys, do: keys, else: config_keys()

    payload = %{data: data} |> maybe_put(:keys, keys) |> Jason.encode!()

    with {:ok, status, _headers, client} <- push_remote(http_client, path, payload),
         :ok <- response_status_ok(http_client, client, status),
         {:ok, response} <- http_client.body(client) do
      Jason.decode(response)
    end
  end

  @doc """
  Fetch from the API room client data, given a path.

  An optional keys parameter is provided for overriding the hard-coded
  keys set during configuration.
  """
  @spec fetch(path :: binary, data :: map, keys :: map) :: {:ok, map} | {:error, term}
  def fetch(path, data, keys \\ nil) do
    fetch(@default_http_client, path, data, keys)
  end

  defp push_remote(http_client, path, payload) do
    endpoint =
      config_api_endpoint()
      |> URI.merge(path)
      |> URI.to_string()

    http_client.post(endpoint, @request_headers, payload)
  end

  defp response_status_ok(http_client, client, status) when is_integer(status) do
    if status in 200..399 do
      :ok
    else
      error_msg =
        case http_client.body(client) do
          {:ok, message} -> message
          _ -> nil
        end

      {:error, {:request_failed, %{status: status, message: Jason.decode!(error_msg)}}}
    end
  end

  defp config_api_endpoint do
    Bonfire.Common.Config.get!([__MODULE__, :api_endpoint])
  end

  defp config_keys do
    Bonfire.Common.Config.get([__MODULE__, :keys])
  end
end
