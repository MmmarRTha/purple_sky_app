defmodule PurpleSkyApp.Repo do
  use Ecto.Repo,
    otp_app: :purple_sky_app,
    adapter: Ecto.Adapters.Postgres
end
