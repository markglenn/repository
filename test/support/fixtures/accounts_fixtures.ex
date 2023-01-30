defmodule Repository.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Repository.Accounts` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-01-29 22:20:00],
        name: "some name"
      })
      |> Repository.Accounts.create_organization()

    organization
  end
end
