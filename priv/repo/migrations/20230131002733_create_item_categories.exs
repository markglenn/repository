defmodule Repository.Repo.Migrations.CreateItemCategories do
  use Ecto.Migration

  def change do
    create table(:item_categories) do
      add :name, :string, null: false
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :parent_id, references(:item_categories, on_delete: :nothing)

      add :archived_at, :naive_datetime
      timestamps()
    end

    create index(:item_categories, [:name])
    create index(:item_categories, [:archived_at])
    create index(:item_categories, [:organization_id])
    create index(:item_categories, [:parent_id])
  end
end
