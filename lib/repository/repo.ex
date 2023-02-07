defmodule Repository.Repo do
  use Ecto.Repo,
    otp_app: :repository,
    adapter: Ecto.Adapters.Postgres

  @spec with_preloads(term, Keyword.t()) :: term
  def with_preloads(results, opts) do
    opts
    |> Keyword.get_values(:preload)
    |> Enum.reduce(results, &preload(&2, &1))
  end
end
