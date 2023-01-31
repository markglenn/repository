defmodule Repository.Materials do
  @moduledoc """
  The Materials context.
  """

  import Ecto.Query, warn: false
  alias Repository.Repo

  alias Repository.Accounts.Organization
  alias Repository.Materials.ItemCategory

  @doc """
  Returns the list of item_categories.

  ## Examples

      iex> list_item_categories()
      [%ItemCategory{}, ...]

  """
  def list_item_categories(%Organization{} = organization) do
    ItemCategory
    |> ItemCategory.unarchived()
    |> ItemCategory.for_organization(organization)
    |> Repo.all()
  end

  @doc """
  Gets a single item_category.

  Raises `Ecto.NoResultsError` if the Item category does not exist.

  ## Examples

      iex> get_item_category!(123)
      %ItemCategory{}

      iex> get_item_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_category!(%Organization{} = organization, id) do
    ItemCategory
    |> ItemCategory.unarchived()
    |> ItemCategory.for_organization(organization)
    |> Repo.get!(id)
  end

  @doc """
  Creates a item_category.

  ## Examples

      iex> create_item_category(%{field: value})
      {:ok, %ItemCategory{}}

      iex> create_item_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_category(%Organization{} = organization, attrs \\ %{}) do
    organization
    |> Ecto.build_assoc(:item_categories)
    |> ItemCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_category.

  ## Examples

      iex> update_item_category(item_category, %{field: new_value})
      {:ok, %ItemCategory{}}

      iex> update_item_category(item_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_category(%ItemCategory{} = item_category, attrs) do
    item_category
    |> ItemCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_category.

  ## Examples

      iex> delete_item_category(item_category)
      {:ok, %ItemCategory{}}

      iex> delete_item_category(item_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_category(%ItemCategory{} = item_category) do
    item_category
    |> ItemCategory.archive_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_category changes.

  ## Examples

      iex> change_item_category(item_category)
      %Ecto.Changeset{data: %ItemCategory{}}

  """
  def change_item_category(%ItemCategory{} = item_category, attrs \\ %{}) do
    ItemCategory.changeset(item_category, attrs)
  end
end
