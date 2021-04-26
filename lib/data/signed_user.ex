defmodule Bonfire.Reflow.Data.Signed do
  use Pointers.Mixin,
    otp_app: :bonfire_reflow,
    source: "bonfire_reflow_signed"

  mixin_schema do
    field(:signature, :string)
  end
end
