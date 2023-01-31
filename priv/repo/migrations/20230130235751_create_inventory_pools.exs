defmodule Repository.Repo.Migrations.CreateInventoryPools do
  use Ecto.Migration

  def change do
    create table(:inventory_pools) do
      add :name, :string, null: false
      add :archived_at, :naive_datetime
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:inventory_pools, [:organization_id])
    create index(:inventory_pools, [:archived_at])
    create index(:inventory_pools, [:name])
  end
end
