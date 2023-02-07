defmodule Repository.Inventories do
  @moduledoc """
  The Inventories context.
  """

  import Ecto.Query, warn: false
  alias Repository.Repo

  alias Repository.Accounts.Organization
  alias Repository.Inventories.InventoryPool

  @spec list_inventory_pools(Organization.t(), Keyword.t()) :: list(InventoryPool.t())
  @doc """
  Returns the list of inventory_pools.

  ## Examples

      iex> list_inventory_pools(organization)
      [%InventoryPool{}, ...]

  """
  def list_inventory_pools(%Organization{} = organization, opts \\ []) do
    InventoryPool
    |> InventoryPool.unarchived()
    |> InventoryPool.for_organization(organization)
    |> Repo.all()
    |> with_preloads(opts)
  end

  @spec get_inventory_pool!(Organization.t(), term, Keyword.t()) :: InventoryPool.t()
  @doc """
  Gets a single inventory_pool.

  Raises `Ecto.NoResultsError` if the Inventory pool does not exist.

  ## Examples

      iex> get_inventory_pool!(organization, 123)
      %InventoryPool{}

      iex> get_inventory_pool!(organization, 456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory_pool!(%Organization{} = organization, id, opts \\ []) do
    InventoryPool
    |> InventoryPool.unarchived()
    |> InventoryPool.for_organization(organization)
    |> Repo.get!(id)
    |> with_preloads(opts)
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
    Repo.archive(inventory_pool)
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

  alias Repository.Inventories.Warehouse

  @doc """
  Returns the list of warehouses.

  ## Examples

      iex> list_warehouses()
      [%Warehouse{}, ...]

  """
  def list_warehouses(%Organization{} = organization) do
    Warehouse
    |> Warehouse.unarchived()
    |> Warehouse.for_organization(organization)
    |> Repo.all()
  end

  @doc """
  Gets a single warehouse.

  Raises `Ecto.NoResultsError` if the Warehouse does not exist.

  ## Examples

      iex> get_warehouse!(123)
      %Warehouse{}

      iex> get_warehouse!(456)
      ** (Ecto.NoResultsError)

  """
  def get_warehouse!(%Organization{} = organization, id) do
    Warehouse
    |> Warehouse.unarchived()
    |> Warehouse.for_organization(organization)
    |> Repo.get!(id)
  end

  @doc """
  Creates a warehouse.

  ## Examples

      iex> create_warehouse(%{field: value})
      {:ok, %Warehouse{}}

      iex> create_warehouse(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_warehouse(%Organization{} = organization, attrs \\ %{}) do
    organization
    |> Ecto.build_assoc(:warehouses)
    |> Warehouse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a warehouse.

  ## Examples

      iex> update_warehouse(warehouse, %{field: new_value})
      {:ok, %Warehouse{}}

      iex> update_warehouse(warehouse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_warehouse(%Warehouse{} = warehouse, attrs) do
    warehouse
    |> Warehouse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a warehouse.

  ## Examples

      iex> delete_warehouse(warehouse)
      {:ok, %Warehouse{}}

      iex> delete_warehouse(warehouse)
      {:error, %Ecto.Changeset{}}

  """
  def delete_warehouse(%Warehouse{} = warehouse) do
    Repo.archive(warehouse)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking warehouse changes.

  ## Examples

      iex> change_warehouse(warehouse)
      %Ecto.Changeset{data: %Warehouse{}}

  """
  def change_warehouse(%Warehouse{} = warehouse, attrs \\ %{}) do
    Warehouse.changeset(warehouse, attrs)
  end

  @spec with_preloads(term, Keyword.t()) :: term
  defp with_preloads(results, opts) do
    opts
    |> Keyword.get_values(:preload)
    |> Enum.reduce(results, &Repo.preload(&2, &1))
  end
end
