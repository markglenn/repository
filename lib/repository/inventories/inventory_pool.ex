defmodule Repository.Inventories.InventoryPool do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable
  alias Repository.Accounts.Organization

  @type t :: %__MODULE__{
          name: String.t(),
          organization_id: pos_integer(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "inventory_pools" do
    field :archived_at, :naive_datetime
    field :name, :string
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(inventory_pool, attrs) do
    inventory_pool
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @spec for_organization(Ecto.Queryable.t(), Organization.t()) :: Ecto.Query.t()
  def for_organization(queryable \\ __MODULE__, %Organization{id: organization_id}) do
    from q in queryable,
      where: q.organization_id == ^organization_id
  end
end
