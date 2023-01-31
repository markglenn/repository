defmodule Repository.MaterialsTest do
  use Repository.DataCase

  alias Repository.Materials

  describe "item_categories" do
    alias Repository.Materials.ItemCategory

    import Repository.MaterialsFixtures

    @invalid_attrs %{archived_at: nil, name: nil}

    test "list_item_categories/0 returns all item_categories" do
      item_category = item_category_fixture()
      assert Materials.list_item_categories() == [item_category]
    end

    test "get_item_category!/1 returns the item_category with given id" do
      item_category = item_category_fixture()
      assert Materials.get_item_category!(item_category.id) == item_category
    end

    test "create_item_category/1 with valid data creates a item_category" do
      valid_attrs = %{archived_at: ~N[2023-01-30 00:27:00], name: "some name"}

      assert {:ok, %ItemCategory{} = item_category} = Materials.create_item_category(valid_attrs)
      assert item_category.archived_at == ~N[2023-01-30 00:27:00]
      assert item_category.name == "some name"
    end

    test "create_item_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Materials.create_item_category(@invalid_attrs)
    end

    test "update_item_category/2 with valid data updates the item_category" do
      item_category = item_category_fixture()
      update_attrs = %{archived_at: ~N[2023-01-31 00:27:00], name: "some updated name"}

      assert {:ok, %ItemCategory{} = item_category} = Materials.update_item_category(item_category, update_attrs)
      assert item_category.archived_at == ~N[2023-01-31 00:27:00]
      assert item_category.name == "some updated name"
    end

    test "update_item_category/2 with invalid data returns error changeset" do
      item_category = item_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Materials.update_item_category(item_category, @invalid_attrs)
      assert item_category == Materials.get_item_category!(item_category.id)
    end

    test "delete_item_category/1 deletes the item_category" do
      item_category = item_category_fixture()
      assert {:ok, %ItemCategory{}} = Materials.delete_item_category(item_category)
      assert_raise Ecto.NoResultsError, fn -> Materials.get_item_category!(item_category.id) end
    end

    test "change_item_category/1 returns a item_category changeset" do
      item_category = item_category_fixture()
      assert %Ecto.Changeset{} = Materials.change_item_category(item_category)
    end
  end

  describe "items" do
    alias Repository.Materials.Item

    import Repository.MaterialsFixtures

    @invalid_attrs %{archived_at: nil, name: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Materials.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Materials.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{archived_at: ~N[2023-01-30 00:58:00], name: "some name"}

      assert {:ok, %Item{} = item} = Materials.create_item(valid_attrs)
      assert item.archived_at == ~N[2023-01-30 00:58:00]
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Materials.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{archived_at: ~N[2023-01-31 00:58:00], name: "some updated name"}

      assert {:ok, %Item{} = item} = Materials.update_item(item, update_attrs)
      assert item.archived_at == ~N[2023-01-31 00:58:00]
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Materials.update_item(item, @invalid_attrs)
      assert item == Materials.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Materials.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Materials.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Materials.change_item(item)
    end
  end
end
