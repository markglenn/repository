defmodule Repository.Fulfillment.Order do
  use Ecto.Schema
  import Ecto.Changeset

  use Repository.Archivable

  alias Repository.Accounts.Organization

  @type t :: %__MODULE__{
          id: pos_integer(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          organization_id: pos_integer(),
          reference_id: String.t(),
          archived_at: NaiveDateTime.t() | nil,
          fulfilled_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "orders" do
    belongs_to(:organization, Organization)
    field(:reference_id, :string)

    field(:archived_at, :naive_datetime)
    field(:fulfilled_at, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:reference_id, :fulfilled_at])
    |> validate_required([:reference_id])
    |> foreign_key_constraint(:organization_id)
  end

  @spec for_organization(Ecto.Queryable.t(), Organization.t()) :: Ecto.Query.t()
  def for_organization(queryable \\ __MODULE__, %Organization{id: organization_id}) do
    from(q in queryable, where: q.organization_id == ^organization_id)
  end
end
