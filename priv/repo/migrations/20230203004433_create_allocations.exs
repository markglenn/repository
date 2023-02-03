defmodule Repository.Repo.Migrations.CreateAllocations do
  use Ecto.Migration

  def change do
    create table(:allocations) do
      add :order_line_id, references(:order_lines, on_delete: :nothing), null: false
      add :inventory_pool_id, references(:inventory_pools, on_delete: :nothing), null: false

      add :quantity, :decimal, precision: 12, scale: 4, null: false

      add :archived_at, :naive_datetime
      timestamps()
    end

    create index(:allocations, [:order_line_id])
    create index(:allocations, [:inventory_pool_id])
    create index(:allocations, [:archived_at])
  end
end
