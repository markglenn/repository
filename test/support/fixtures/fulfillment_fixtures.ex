defmodule Repository.FulfillmentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Repository.Fulfillment` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-02-01 00:12:00],
        fulfilled_at: ~N[2023-02-01 00:12:00],
        reference_id: "some reference_id"
      })
      |> Repository.Fulfillment.create_order()

    order
  end
end
