defmodule Repository.Repo do
  use Ecto.Repo,
    otp_app: :repository,
    adapter: Ecto.Adapters.Postgres
end
