defmodule Repository.Inventories.InventoryPool do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable

  alias Repository.Accounts.Organization
  alias Repository.Inventories.Warehouse

  @type t :: %__MODULE__{
          name: String.t(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          warehouse: Warehouse.t() | Ecto.Association.NotLoaded.t(),
          organization_id: pos_integer(),
          warehouse_id: pos_integer(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "inventory_pools" do
    field(:archived_at, :naive_datetime)
    field(:name, :string)
    belongs_to(:organization, Organization)
    belongs_to(:warehouse, Warehouse)

    timestamps()
  end

  @doc false
  def changeset(inventory_pool, attrs) do
    inventory_pool
    |> cast(attrs, [:name, :warehouse_id])
    |> validate_required([:name, :warehouse_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:warehouse_id)
  end

  @spec for_organization(Ecto.Queryable.t(), Organization.t()) :: Ecto.Query.t()
  def for_organization(queryable \\ __MODULE__, %Organization{id: organization_id}) do
    from(q in queryable, where: q.organization_id == ^organization_id)
  end
end
