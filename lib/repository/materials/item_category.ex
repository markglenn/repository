defmodule Repository.Materials.ItemCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Repository.Accounts.Organization

  use Repository.Archivable

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          parent: t() | nil | Ecto.Association.NotLoaded.t(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "item_categories" do
    field :name, :string
    belongs_to :organization, Organization
    belongs_to :parent, __MODULE__

    field :archived_at, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(item_category, attrs) do
    item_category
    |> cast(attrs, [:name, :parent_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:parent_id)
  end

  @spec for_organization(Ecto.Queryable.t(), Organization.t()) :: Ecto.Query.t()
  def for_organization(queryable \\ __MODULE__, %Organization{id: organization_id}) do
    from q in queryable,
      where: q.organization_id == ^organization_id
  end
end
