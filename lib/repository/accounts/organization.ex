defmodule Repository.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "organizations" do
    field :name, :string

    field :archived_at, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
