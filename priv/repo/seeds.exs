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

{:ok, item_category} =
  Repository.Materials.create_item_category(organization, %{name: "Wine & Alcohol"})

{:ok, _item} =
  Repository.Materials.create_item(organization, %{
    name: "2019 Chardonnay",
    item_category_id: item_category.id
  })

{:ok, _warehouse} =
  Repository.Inventories.create_warehouse(organization, %{name: "Gurnee Warehouse"})
