defmodule Repository.Repo.Migrations.CreateOrderLines do
  use Ecto.Migration

  def change do
    create table(:order_lines) do
      add :reference_id, :string
      add :quantity, :decimal, precision: 12, scale: 4, null: false
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :item_id, references(:items, on_delete: :nothing), null: false
      add :inventory_pool_id, references(:inventory_pools, on_delete: :nothing)

      add :archived_at, :naive_datetime
      timestamps()
    end

    create index(:order_lines, [:order_id, :reference_id])
    create index(:order_lines, [:item_id])
    create index(:order_lines, [:inventory_pool_id])
    create index(:order_lines, [:archived_at])
  end
end
