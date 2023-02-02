defmodule Repository.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:organization_id, references(:organizations, on_delete: :nothing), null: false)
      add(:reference_id, :string, null: false)
      add(:fulfilled_at, :naive_datetime)
      add(:archived_at, :naive_datetime)

      timestamps()
    end

    create(index(:orders, [:reference_id]))
    create(index(:orders, [:fulfilled_at]))
    create(index(:orders, [:archived_at]))
  end
end
