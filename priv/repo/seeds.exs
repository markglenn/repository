# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Repository.Repo.insert!(%Repository.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, organization} = Repository.Accounts.create_organization(%{name: "Wine Warehouse"})

{:ok, _pool} =
  Repository.Inventories.create_inventory_pool(organization, %{name: "Primary Stock"})
