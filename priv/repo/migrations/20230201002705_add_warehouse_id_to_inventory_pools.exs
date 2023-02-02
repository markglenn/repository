defmodule Repository.Repo.Migrations.AddWarehouseIdToInventoryPools do
  use Ecto.Migration

  def change do
    alter table("inventory_pools") do
      add :warehouse_id, references(:warehouses, on_delete: :nothing), null: false
    end

    create index(:inventory_pools, [:warehouse_id])
  end
end
