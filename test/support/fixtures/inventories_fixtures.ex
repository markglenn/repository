defmodule Repository.InventoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Repository.Inventories` context.
  """

  @doc """
  Generate a inventory_pool.
  """
  def inventory_pool_fixture(attrs \\ %{}) do
    {:ok, inventory_pool} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-01-29 23:57:00],
        name: "some name"
      })
      |> Repository.Inventories.create_inventory_pool()

    inventory_pool
  end
end
