defmodule Repository.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable

  alias Repository.Fulfillment.Order
  alias Repository.Inventories.{InventoryPool, Warehouse}
  alias Repository.Materials.{ItemCategory, Item}

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          inventory_pools: [InventoryPool.t()] | Ecto.Association.NotLoaded.t(),
          item_categories: [ItemCategory.t()] | Ecto.Association.NotLoaded.t(),
          orders: [Order.t()] | Ecto.Association.NotLoaded.t(),
          warehouses: [Warehouse.t()] | Ecto.Association.NotLoaded.t(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "organizations" do
    field(:name, :string)

    has_many(:inventory_pools, InventoryPool)
    has_many(:item_categories, ItemCategory)
    has_many(:items, Item)
    has_many(:warehouses, Warehouse)
    has_many(:orders, Order)

    field(:archived_at, :naive_datetime)
    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
