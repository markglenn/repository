defmodule Repository.Repo.Migrations.CreateWarehouses do
  use Ecto.Migration

  def change do
    create table(:warehouses) do
      add :name, :string, null: false
      add :organization_id, references(:organizations, on_delete: :nothing), null: false

      add :archived_at, :naive_datetime
      timestamps()
    end

    create index(:warehouses, [:archived_at])
    create index(:warehouses, [:organization_id])
    create index(:warehouses, [:name])
  end
end
