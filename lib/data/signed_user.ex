defmodule Bonfire.Reflow.Data.SignedUser do
  use Pointers.Mixin,
    otp_app: :bonfire_reflow,
    source: "bonfire_reflow_signed_user"

  mixin_schema do
    field(:public_key, :string)
  end
end
