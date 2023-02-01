defmodule Repository.Inventories.Warehouse do
  use Ecto.Schema
  import Ecto.Changeset
  use Repository.Archivable

  alias Repository.Accounts.Organization

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          organization_id: pos_integer(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "warehouses" do
    field(:name, :string)
    belongs_to(:organization, Organization)

    field(:archived_at, :naive_datetime)
    timestamps()
  end

  @doc false
  def changeset(warehouse, attrs) do
    warehouse
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> foreign_key_constraint(:organization_id)
  end

  @spec for_organization(Ecto.Queryable.t(), Organization.t()) :: Ecto.Query.t()
  def for_organization(queryable \\ __MODULE__, %Organization{id: organization_id}) do
    from(q in queryable,
      where: q.organization_id == ^organization_id
    )
  end
end
