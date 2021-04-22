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

  @spec signatures(http_client :: atom, data :: map, keys :: map) :: {:ok, map} | {:error, term}
  def signatures(http_client, data, keys) do
    keys = if keys, do: keys, else: config_keys()

    payload = %{data: data} |> maybe_put(:keys, keys) |> Jason.encode!()

    with {:ok, status, _headers, client} <- push_remote(http_client, payload),
         :ok <- response_status_ok(http_client, client, status),
         {:ok, signatures} <- http_client.body(client) do
      Jason.decode(signatures)
    end
  end

  @doc """
  Fetch signatures from the API room client for the given data.

  An optional keys parameter is provided for overriding the hard-coded
  keys set during configuration.
  """
  @spec signatures(data :: map, keys :: map) :: {:ok, map} | {:error, term}
  def signatures(data, keys \\ nil) do
    signatures(@default_http_client, data, keys)
  end

  defp push_remote(http_client, payload),
    do: http_client.post(config_api_endpoint(), @request_headers, payload)

  defp response_status_ok(http_client, client, status) when is_integer(status) do
    if status in 200..399 do
      :ok
    else
      error_msg =
        case http_client.body(client) do
          {:ok, message} -> message
          _ -> nil
        end

      {:error, {:request_failed, %{status: status, message: error_msg}}}
    end
  end

  defp config_api_endpoint do
    Bonfire.Common.Config.get!([__MODULE__, :api_endpoint])
  end

  defp config_keys do
    Bonfire.Common.Config.get([__MODULE__, :keys])
  end
end
