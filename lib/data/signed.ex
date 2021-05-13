defmodule Bonfire.Reflow.Data.Signed do
  use Pointers.Mixin,
    otp_app: :bonfire_reflow,
    source: "bonfire_reflow_signed"

  alias Ecto.Changeset

  mixin_schema do
    field(:signature, :map)
  end

  @required [:signature]
  @cast @required

  def changeset(%{} = signature) do
    %__MODULE__{}
    |> Changeset.cast(%{signature: signature}, @cast)
    |> Changeset.validate_required(@required)
  end
end
