defmodule Repository.MaterialsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Repository.Materials` context.
  """

  @doc """
  Generate a item_category.
  """
  def item_category_fixture(attrs \\ %{}) do
    {:ok, item_category} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-01-30 00:27:00],
        name: "some name"
      })
      |> Repository.Materials.create_item_category()

    item_category
  end
end
