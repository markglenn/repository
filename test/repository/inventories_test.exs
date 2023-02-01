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

  describe "warehouses" do
    alias Repository.Inventories.Warehouse

    import Repository.InventoriesFixtures

    @invalid_attrs %{archived_at: nil, name: nil}

    test "list_warehouses/0 returns all warehouses" do
      warehouse = warehouse_fixture()
      assert Inventories.list_warehouses() == [warehouse]
    end

    test "get_warehouse!/1 returns the warehouse with given id" do
      warehouse = warehouse_fixture()
      assert Inventories.get_warehouse!(warehouse.id) == warehouse
    end

    test "create_warehouse/1 with valid data creates a warehouse" do
      valid_attrs = %{archived_at: ~N[2023-01-30 23:52:00], name: "some name"}

      assert {:ok, %Warehouse{} = warehouse} = Inventories.create_warehouse(valid_attrs)
      assert warehouse.archived_at == ~N[2023-01-30 23:52:00]
      assert warehouse.name == "some name"
    end

    test "create_warehouse/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_warehouse(@invalid_attrs)
    end

    test "update_warehouse/2 with valid data updates the warehouse" do
      warehouse = warehouse_fixture()
      update_attrs = %{archived_at: ~N[2023-01-31 23:52:00], name: "some updated name"}

      assert {:ok, %Warehouse{} = warehouse} = Inventories.update_warehouse(warehouse, update_attrs)
      assert warehouse.archived_at == ~N[2023-01-31 23:52:00]
      assert warehouse.name == "some updated name"
    end

    test "update_warehouse/2 with invalid data returns error changeset" do
      warehouse = warehouse_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.update_warehouse(warehouse, @invalid_attrs)
      assert warehouse == Inventories.get_warehouse!(warehouse.id)
    end

    test "delete_warehouse/1 deletes the warehouse" do
      warehouse = warehouse_fixture()
      assert {:ok, %Warehouse{}} = Inventories.delete_warehouse(warehouse)
      assert_raise Ecto.NoResultsError, fn -> Inventories.get_warehouse!(warehouse.id) end
    end

    test "change_warehouse/1 returns a warehouse changeset" do
      warehouse = warehouse_fixture()
      assert %Ecto.Changeset{} = Inventories.change_warehouse(warehouse)
    end
  end
end
