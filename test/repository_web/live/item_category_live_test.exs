defmodule RepositoryWeb.ItemCategoryLiveTest do
  use RepositoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Repository.MaterialsFixtures

  @create_attrs %{archived_at: "2023-01-30T00:27:00", name: "some name"}
  @update_attrs %{archived_at: "2023-01-31T00:27:00", name: "some updated name"}
  @invalid_attrs %{archived_at: nil, name: nil}

  defp create_item_category(_) do
    item_category = item_category_fixture()
    %{item_category: item_category}
  end

  describe "Index" do
    setup [:create_item_category]

    test "lists all item_categories", %{conn: conn, item_category: item_category} do
      {:ok, _index_live, html} = live(conn, ~p"/item_categories")

      assert html =~ "Listing Item categories"
      assert html =~ item_category.name
    end

    test "saves new item_category", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/item_categories")

      assert index_live |> element("a", "New Item category") |> render_click() =~
               "New Item category"

      assert_patch(index_live, ~p"/item_categories/new")

      assert index_live
             |> form("#item_category-form", item_category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#item_category-form", item_category: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/item_categories")

      assert html =~ "Item category created successfully"
      assert html =~ "some name"
    end

    test "updates item_category in listing", %{conn: conn, item_category: item_category} do
      {:ok, index_live, _html} = live(conn, ~p"/item_categories")

      assert index_live |> element("#item_categories-#{item_category.id} a", "Edit") |> render_click() =~
               "Edit Item category"

      assert_patch(index_live, ~p"/item_categories/#{item_category}/edit")

      assert index_live
             |> form("#item_category-form", item_category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#item_category-form", item_category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/item_categories")

      assert html =~ "Item category updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes item_category in listing", %{conn: conn, item_category: item_category} do
      {:ok, index_live, _html} = live(conn, ~p"/item_categories")

      assert index_live |> element("#item_categories-#{item_category.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#item_category-#{item_category.id}")
    end
  end

  describe "Show" do
    setup [:create_item_category]

    test "displays item_category", %{conn: conn, item_category: item_category} do
      {:ok, _show_live, html} = live(conn, ~p"/item_categories/#{item_category}")

      assert html =~ "Show Item category"
      assert html =~ item_category.name
    end

    test "updates item_category within modal", %{conn: conn, item_category: item_category} do
      {:ok, show_live, _html} = live(conn, ~p"/item_categories/#{item_category}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Item category"

      assert_patch(show_live, ~p"/item_categories/#{item_category}/show/edit")

      assert show_live
             |> form("#item_category-form", item_category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#item_category-form", item_category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/item_categories/#{item_category}")

      assert html =~ "Item category updated successfully"
      assert html =~ "some updated name"
    end
  end
end
