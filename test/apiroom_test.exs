defmodule Bonfire.Reflow.ApiroomTest do
  use Bonfire.DataCase, async: true

  alias Bonfire.Reflow.Apiroom

  defmodule HappyPathHttp do
    def post(_url, _headers, _body) do
      {:ok, 200, [], __MODULE__}
    end

    def body(_client) do
      {:ok, Jason.encode!(%{secret: %{message: encrypt("top secret")}})}
    end

    # super duper secure encryption
    defp encrypt(data), do: "encryptedblabla"
  end

  defmodule SadPathHttp do
    def post(_url, _headers, _body) do
      {:ok, 500, [], __MODULE__}
    end

    def body(_client) do
      {:ok, Jason.encode!(%{logs: "blabla", message: "something terrible\n\nindeed!"})}
    end
  end

  describe "signatures" do
    test "without supplied keys" do
      assert {:ok, %{"secret" => %{"message" => message}}} =
        Apiroom.signatures(HappyPathHttp, %{secret: %{message: "test"}}, %{})
      assert message != "test"
    end

    test "when something goes terribly" do
      assert {:error, {:request_failed, _reason}} =
        Apiroom.signatures(SadPathHttp, %{secret: %{message: "test"}}, %{})
    end

    test "with supplied keys" do
      assert {:ok, %{"secret" => %{"message" => message}}} = Apiroom.signatures(
        HappyPathHttp,
        %{secret: %{message: "test"}},
        %{"Alice" => %{
            "private_key" => "psBF05iHz/X8WBpwitJoSsZ7BiKawrdaVfQN3AtTa6I=",
            "public_key" => "BBA0kD35T9lUHR/WhDwBmgg/vMzlu1Vb0qtBjBZ8rbhdtW3AcX6z64a59RqF6FCV5q3lpiFNTmOgA264x1cZHE0=",
          }}
      )
      assert message != "test"
    end
  end
end
