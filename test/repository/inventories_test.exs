defmodule Repository.InventoriesTest do
  use Repository.DataCase

  alias Repository.Inventories

  describe "inventory_pools" do
    alias Repository.Inventories.InventoryPool

    import Repository.InventoriesFixtures

    @invalid_attrs %{archived_at: nil, name: nil}

    test "list_inventory_pools/0 returns all inventory_pools" do
      inventory_pool = inventory_pool_fixture()
      assert Inventories.list_inventory_pools() == [inventory_pool]
    end

    test "get_inventory_pool!/1 returns the inventory_pool with given id" do
      inventory_pool = inventory_pool_fixture()
      assert Inventories.get_inventory_pool!(inventory_pool.id) == inventory_pool
    end

    test "create_inventory_pool/1 with valid data creates a inventory_pool" do
      valid_attrs = %{archived_at: ~N[2023-01-29 23:57:00], name: "some name"}

      assert {:ok, %InventoryPool{} = inventory_pool} = Inventories.create_inventory_pool(valid_attrs)
      assert inventory_pool.archived_at == ~N[2023-01-29 23:57:00]
      assert inventory_pool.name == "some name"
    end

    test "create_inventory_pool/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_inventory_pool(@invalid_attrs)
    end

    test "update_inventory_pool/2 with valid data updates the inventory_pool" do
      inventory_pool = inventory_pool_fixture()
      update_attrs = %{archived_at: ~N[2023-01-30 23:57:00], name: "some updated name"}

      assert {:ok, %InventoryPool{} = inventory_pool} = Inventories.update_inventory_pool(inventory_pool, update_attrs)
      assert inventory_pool.archived_at == ~N[2023-01-30 23:57:00]
      assert inventory_pool.name == "some updated name"
    end

    test "update_inventory_pool/2 with invalid data returns error changeset" do
      inventory_pool = inventory_pool_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.update_inventory_pool(inventory_pool, @invalid_attrs)
      assert inventory_pool == Inventories.get_inventory_pool!(inventory_pool.id)
    end

    test "delete_inventory_pool/1 deletes the inventory_pool" do
      inventory_pool = inventory_pool_fixture()
      assert {:ok, %InventoryPool{}} = Inventories.delete_inventory_pool(inventory_pool)
      assert_raise Ecto.NoResultsError, fn -> Inventories.get_inventory_pool!(inventory_pool.id) end
    end

    test "change_inventory_pool/1 returns a inventory_pool changeset" do
      inventory_pool = inventory_pool_fixture()
      assert %Ecto.Changeset{} = Inventories.change_inventory_pool(inventory_pool)
    end
  end
end
