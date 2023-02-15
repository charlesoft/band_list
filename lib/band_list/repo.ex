defmodule BandList.Repo do
  use Ecto.Repo,
    otp_app: :band_list,
    adapter: Ecto.Adapters.Postgres
end
