defmodule FrontiersSite.Repo do
  use Ecto.Repo,
    otp_app: :frontiers_site,
    adapter: Ecto.Adapters.Postgres
end
