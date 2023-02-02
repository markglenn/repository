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
  def list_item_categories(%Organization{} = organization, opts \\ []) do
    ItemCategory
    |> ItemCategory.unarchived()
    |> ItemCategory.for_organization(organization)
    |> Repo.all()
    |> with_preloads(opts)
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
  def get_item_category!(%Organization{} = organization, id, opts \\ []) do
    ItemCategory
    |> ItemCategory.unarchived()
    |> ItemCategory.for_organization(organization)
    |> Repo.get!(id)
    |> with_preloads(opts)
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

  alias Repository.Materials.Item

  @spec list_items(Organization.t(), Keyword.t()) :: list(Item.t())
  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items(organization)
      [%Item{}, ...]

  """
  def list_items(%Organization{} = organization, opts \\ []) do
    Item
    |> Item.unarchived()
    |> Item.for_organization(organization)
    |> Repo.all()
    |> with_preloads(opts)
  end

  @spec get_item!(Organization.t(), term, Keyword.t()) :: Item.t()
  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(organization, 123)
      %Item{}

      iex> get_item!(organization, 456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(%Organization{} = organization, id, opts \\ []) do
    Item
    |> Item.unarchived()
    |> Item.for_organization(organization)
    |> Repo.get!(id)
    |> with_preloads(opts)
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(%Organization{} = organization, attrs \\ %{}) do
    organization
    |> Ecto.build_assoc(:items)
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_item(Item.t()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    item
    |> Item.archive_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  @spec with_preloads(term, Keyword.t()) :: term
  defp with_preloads(results, opts) do
    opts
    |> Keyword.get_values(:preload)
    |> Enum.reduce(results, &Repo.preload(&2, &1))
  end
end
