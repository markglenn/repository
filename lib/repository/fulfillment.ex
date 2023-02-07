defmodule Repository.Fulfillment do
  @moduledoc """
  The Fulfillment context.
  """

  import Ecto.Query, warn: false
  alias Repository.Repo

  alias Repository.Accounts.Organization
  alias Repository.Fulfillment.{Allocation, Order}

  @spec list_orders(Organization.t(), Keyword.t()) :: list(Order.t())
  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(%Organization{} = organization, opts \\ []) do
    Order
    |> Order.unarchived()
    |> Order.for_organization(organization)
    |> Repo.all()
    |> Repo.with_preloads(opts)
  end

  @spec get_order!(Organization.t(), term, Keyword.t()) :: Order.t()
  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(%Organization{} = organization, id, opts \\ []) do
    Order
    |> Order.unarchived()
    |> Order.for_organization(organization)
    |> Repo.get!(id)
    |> Repo.with_preloads(opts)
  end

  @spec create_order(Organization.t(), :invalid | map()) ::
          {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(%Organization{} = organization, attrs \\ %{}) do
    organization
    |> Ecto.build_assoc(:orders)
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_order(Order.t(), :invalid | map()) ::
          {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_order(Order.t()) :: {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    order
    |> Order.archive_changeset()
    |> Repo.update()
  end

  @spec change_order(Order.t(), :invalid | map()) :: Ecto.Changeset.t()
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias Repository.Fulfillment.OrderLine

  @spec list_order_lines(Order.t(), Keyword.t()) :: list(OrderLine.t())
  @doc """
  Returns the list of order_lines.

  ## Examples

      iex> list_order_lines(order)
      [%OrderLine{}, ...]

  """
  def list_order_lines(%Order{} = order, opts \\ []) do
    order
    |> OrderLine.for_order()
    |> OrderLine.unarchived()
    |> Repo.all()
    |> Repo.with_preloads(opts)
  end

  @spec get_order_line!(Order.t(), term(), Keyword.t()) :: OrderLine.t()
  @doc """
  Gets a single order_line.

  Raises `Ecto.NoResultsError` if the Order line does not exist.

  ## Examples

      iex> get_order_line!(order, 123)
      %OrderLine{}

      iex> get_order_line!(order, 456)
      ** (Ecto.NoResultsError)

  """
  def get_order_line!(%Order{} = order, id, opts \\ []) do
    order
    |> OrderLine.for_order()
    |> OrderLine.unarchived()
    |> Repo.get!(id)
    |> Repo.with_preloads(opts)
  end

  @spec create_order_line(Order.t(), :invalid | map()) ::
          {:ok, OrderLine.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Creates a order_line.

  ## Examples

      iex> create_order_line(order, %{field: value})
      {:ok, %OrderLine{}}

      iex> create_order_line(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_line(%Order{} = order, attrs \\ %{}) do
    order
    |> Ecto.build_assoc(:order_lines)
    |> OrderLine.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_order_line(OrderLine.t(), :invalid | map()) ::
          {:ok, OrderLine.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Updates a order_line.

  ## Examples

      iex> update_order_line(order_line, %{field: new_value})
      {:ok, %OrderLine{}}

      iex> update_order_line(order_line, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_line(%OrderLine{} = order_line, attrs) do
    order_line
    |> OrderLine.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_order_line(OrderLine.t()) :: {:ok, OrderLine.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Deletes a order_line.

  ## Examples

      iex> delete_order_line(order_line)
      {:ok, %OrderLine{}}

      iex> delete_order_line(order_line)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_line(%OrderLine{} = order_line) do
    order_line
    |> OrderLine.archive_changeset()
    |> Repo.update()
  end

  @spec change_order_line(OrderLine.t(), :invalid | map()) :: Ecto.Changeset.t()
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_line changes.

  ## Examples

      iex> change_order_line(order_line)
      %Ecto.Changeset{data: %OrderLine{}}

  """
  def change_order_line(%OrderLine{} = order_line, attrs \\ %{}) do
    OrderLine.changeset(order_line, attrs)
  end

  @spec list_allocations(OrderLine.t() | Order.t(), Keyword.t() | nil) :: list(Allocation.t())
  @doc """
  Returns the list of allocations.

  ## Examples

      iex> list_allocations(order_line)
      [%Allocation{}, ...]

  """
  def list_allocations(order_line_or_order, opts \\ [])

  def list_allocations(%OrderLine{} = order_line, opts) do
    Allocation
    |> Allocation.unarchived()
    |> Allocation.for_order_line(order_line)
    |> Repo.all()
    |> Repo.with_preloads(opts)
  end

  def list_allocations(%Order{} = order, opts) do
    Allocation
    |> Allocation.unarchived()
    |> Allocation.for_order(order)
    |> Repo.all()
    |> Repo.with_preloads(opts)
  end

  @spec get_allocation!(OrderLine.t(), term, keyword | nil) :: Allocation.t()
  @doc """
  Gets a single allocation.

  Raises `Ecto.NoResultsError` if the Allocation does not exist.

  ## Examples

      iex> get_allocation!(123)
      %Allocation{}

      iex> get_allocation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_allocation!(%OrderLine{} = order_line, id, opts \\ []) do
    Allocation
    |> Allocation.unarchived()
    |> Allocation.for_order_line(order_line)
    |> Repo.get!(id)
    |> Repo.with_preloads(opts)
  end

  @spec create_allocation(OrderLine.t(), :invalid | map()) ::
          {:ok, Allocation.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Creates a allocation.

  ## Examples

      iex> create_allocation(%{field: value})
      {:ok, %Allocation{}}

      iex> create_allocation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_allocation(%OrderLine{} = order_line, attrs \\ %{}) do
    order_line
    |> Ecto.build_assoc(:allocations)
    |> Allocation.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_allocation(Allocation.t(), :invalid | map()) ::
          {:ok, Allocation.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Updates a allocation.

  ## Examples

      iex> update_allocation(allocation, %{field: new_value})
      {:ok, %Allocation{}}

      iex> update_allocation(allocation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_allocation(%Allocation{} = allocation, attrs) do
    allocation
    |> Allocation.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_allocation(Allocation.t()) :: {:ok, Allocation.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Deletes a allocation.

  ## Examples

      iex> delete_allocation(allocation)
      {:ok, %Allocation{}}

      iex> delete_allocation(allocation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_allocation(%Allocation{} = allocation) do
    allocation
    |> Allocation.archive_changeset()
    |> Repo.update()
  end

  @spec change_allocation(Allocation.t(), :invalid | map()) :: Ecto.Changeset.t()
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking allocation changes.

  ## Examples

      iex> change_allocation(allocation)
      %Ecto.Changeset{data: %Allocation{}}

  """
  def change_allocation(%Allocation{} = allocation, attrs \\ %{}) do
    Allocation.changeset(allocation, attrs)
  end
end
