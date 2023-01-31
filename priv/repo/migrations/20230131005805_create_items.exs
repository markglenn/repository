defmodule Repository.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
      add :item_category_id, references(:item_categories, on_delete: :nothing)

      add :archived_at, :naive_datetime
      timestamps()
    end

    create index(:items, [:organization_id])
    create index(:items, [:item_category_id])
    create index(:items, [:archived_at])
    create index(:items, [:name])
  end
end
