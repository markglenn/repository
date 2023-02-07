defmodule Repository.Fulfillment.Allocation do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable

  alias Repository.Fulfillment.{Order, OrderLine}
  alias Repository.Inventories.InventoryPool

  @type t :: %__MODULE__{
          id: pos_integer(),
          quantity: Decimal.t(),
          order_line: OrderLine.t() | Ecto.Association.NotLoaded.t(),
          order_line_id: pos_integer(),
          inventory_pool: InventoryPool.t() | Ecto.Association.NotLoaded.t(),
          inventory_pool_id: pos_integer(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "allocations" do
    field :quantity, :decimal
    belongs_to :order_line, OrderLine
    belongs_to :inventory_pool, InventoryPool

    field :archived_at, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(allocation, attrs) do
    allocation
    |> cast(attrs, [:quantity, :inventory_pool_id])
    |> validate_required([:quantity, :inventory_pool_id])
  end

  @spec for_order_line(Ecto.Queryable.t(), OrderLine.t()) :: Ecto.Query.t()
  def for_order_line(queryable \\ __MODULE__, %OrderLine{id: order_line_id}) do
    from(q in queryable, where: q.order_line_id == ^order_line_id)
  end

  @spec for_order(Ecto.Queryable.t(), Order.t()) :: Ecto.Query.t()
  def for_order(queryable \\ __MODULE__, %Order{id: order_id}) do
    from(q in queryable,
      join: ol in assoc(q, :order_line),
      where: ol.order_id == ^order_id
    )
  end
end
