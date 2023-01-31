defmodule Repository.Inventories do
  @moduledoc """
  The Inventories context.
  """

  import Ecto.Query, warn: false
  alias Repository.Repo

  alias Repository.Accounts.Organization
  alias Repository.Inventories.InventoryPool

  @doc """
  Returns the list of inventory_pools.

  ## Examples

      iex> list_inventory_pools()
      [%InventoryPool{}, ...]

  """
  def list_inventory_pools(%Organization{} = organization) do
    InventoryPool
    |> InventoryPool.unarchived()
    |> InventoryPool.for_organization(organization)
    |> Repo.all()
  end

  @doc """
  Gets a single inventory_pool.

  Raises `Ecto.NoResultsError` if the Inventory pool does not exist.

  ## Examples

      iex> get_inventory_pool!(123)
      %InventoryPool{}

      iex> get_inventory_pool!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory_pool!(%Organization{} = organization, id) do
    InventoryPool
    |> InventoryPool.unarchived()
    |> InventoryPool.for_organization(organization)
    |> Repo.get!(id)
  end

  @doc """
  Creates a inventory_pool.

  ## Examples

      iex> create_inventory_pool(%{field: value})
      {:ok, %InventoryPool{}}

      iex> create_inventory_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory_pool(%Organization{} = organization, attrs \\ %{}) do
    organization
    |> Ecto.build_assoc(:inventory_pools)
    |> InventoryPool.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inventory_pool.

  ## Examples

      iex> update_inventory_pool(inventory_pool, %{field: new_value})
      {:ok, %InventoryPool{}}

      iex> update_inventory_pool(inventory_pool, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory_pool(%InventoryPool{} = inventory_pool, attrs) do
    inventory_pool
    |> InventoryPool.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory_pool.

  ## Examples

      iex> delete_inventory_pool(inventory_pool)
      {:ok, %InventoryPool{}}

      iex> delete_inventory_pool(inventory_pool)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory_pool(%InventoryPool{} = inventory_pool) do
    inventory_pool
    |> InventoryPool.archive_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventory_pool changes.

  ## Examples

      iex> change_inventory_pool(inventory_pool)
      %Ecto.Changeset{data: %InventoryPool{}}

  """
  def change_inventory_pool(%InventoryPool{} = inventory_pool, attrs \\ %{}) do
    InventoryPool.changeset(inventory_pool, attrs)
  end
end
