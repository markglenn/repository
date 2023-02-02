defmodule Repository.Fulfillment.OrderLine do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable

  alias Repository.Fulfillment.Order
  alias Repository.Inventories.InventoryPool
  alias Repository.Materials.Item

  @type t :: %__MODULE__{
          id: pos_integer(),
          order: Order.t() | Ecto.Association.NotLoaded.t(),
          order_id: pos_integer(),
          item: Item.t() | Ecto.Association.NotLoaded.t(),
          item_id: pos_integer(),
          inventory_pool: InventoryPool.t() | nil | Ecto.Association.NotLoaded.t(),
          inventory_pool_id: pos_integer() | nil,
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "order_lines" do
    field(:quantity, :decimal)
    field(:reference_id, :string)
    belongs_to(:order, Order)
    belongs_to(:item, Item)
    belongs_to(:inventory_pool, InventoryPool)

    field(:archived_at, :naive_datetime)
    timestamps()
  end

  @doc false
  def changeset(order_line, attrs) do
    order_line
    |> cast(attrs, [:reference_id, :quantity, :item_id, :inventory_pool_id])
    |> validate_required([:quantity, :item_id, :order_id])
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:item_id)
    |> foreign_key_constraint(:inventory_pool_id)
  end

  @spec for_order(Ecto.Queryable.t(), Order.t()) :: Ecto.Query.t()
  def for_order(queryable \\ __MODULE__, %Order{id: order_id}) do
    from(q in queryable, where: q.order_id == ^order_id)
  end
end
