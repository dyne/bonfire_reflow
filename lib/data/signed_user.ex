defmodule Bonfire.Reflow.Data.SignedUser do
  use Pointers.Mixin,
    otp_app: :bonfire_reflow,
    source: "bonfire_reflow_signed_user"

  alias Ecto.Changeset

  mixin_schema do
    field(:public_key, :string)
  end

  @requierd [:public_key]
  @cast @required

  def changeset(public_key) when is_binary(public_key) do
    %__MODULE__{}
    |> Changeset.cast(%{public_key: public_key}, @cast)
    |> Changeset.validate_required(@required)
  end
end
