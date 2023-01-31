defmodule Repository.Materials.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Repository.Accounts.Organization
  alias Repository.Materials.ItemCategory

  use Repository.Archivable

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          organization_id: pos_integer(),
          item_category: ItemCategory.t() | nil | Ecto.Association.NotLoaded.t(),
          item_category_id: pos_integer(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "items" do
    field :name, :string
    belongs_to :organization, Organization
    belongs_to :item_category, ItemCategory

    field :archived_at, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :item_category_id])
    |> validate_required([:name, :item_category_id])
    |> foreign_key_constraint(:organization)
    |> foreign_key_constraint(:item_category)
  end

  @spec for_organization(Ecto.Queryable.t(), Organization.t()) :: Ecto.Query.t()
  def for_organization(queryable \\ __MODULE__, %Organization{id: organization_id}) do
    from q in queryable,
      where: q.organization_id == ^organization_id
  end
end
