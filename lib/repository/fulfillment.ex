defmodule Repository.Fulfillment do
  @moduledoc """
  The Fulfillment context.
  """

  import Ecto.Query, warn: false
  alias Repository.Repo

  alias Repository.Accounts.Organization
  alias Repository.Fulfillment.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(%Organization{} = organization) do
    Order
    |> Order.unarchived()
    |> Order.for_organization(organization)
    |> Repo.all()
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(%Organization{} = organization, id) do
    Order
    |> Order.unarchived()
    |> Order.for_organization(organization)
    |> Repo.get!(id)
  end

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

  @doc """
  Returns the list of order_lines.

  ## Examples

      iex> list_order_lines()
      [%OrderLine{}, ...]

  """
  def list_order_lines(%Order{} = order, opts \\ []) do
    order
    |> OrderLine.for_order()
    |> OrderLine.unarchived()
    |> Repo.all()
    |> with_preloads(opts)
  end

  @doc """
  Gets a single order_line.

  Raises `Ecto.NoResultsError` if the Order line does not exist.

  ## Examples

      iex> get_order_line!(123)
      %OrderLine{}

      iex> get_order_line!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_line!(%Order{} = order, id, opts \\ []) do
    order
    |> OrderLine.for_order()
    |> OrderLine.unarchived()
    |> Repo.get!(id)
    |> with_preloads(opts)
  end

  @doc """
  Creates a order_line.

  ## Examples

      iex> create_order_line(%{field: value})
      {:ok, %OrderLine{}}

      iex> create_order_line(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_line(%Order{} = order, attrs \\ %{}) do
    order
    |> Ecto.build_assoc(:order_lines)
    |> OrderLine.changeset(attrs)
    |> Repo.insert()
  end

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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_line changes.

  ## Examples

      iex> change_order_line(order_line)
      %Ecto.Changeset{data: %OrderLine{}}

  """
  def change_order_line(%OrderLine{} = order_line, attrs \\ %{}) do
    OrderLine.changeset(order_line, attrs)
  end

  @spec with_preloads(term, Keyword.t()) :: term
  defp with_preloads(results, opts) do
    opts
    |> Keyword.get_values(:preload)
    |> Enum.reduce(results, &Repo.preload(&2, &1))
  end
end
