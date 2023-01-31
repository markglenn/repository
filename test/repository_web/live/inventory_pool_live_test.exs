defmodule RepositoryWeb.InventoryPoolLiveTest do
  use RepositoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Repository.InventoriesFixtures

  @create_attrs %{archived_at: "2023-01-29T23:57:00", name: "some name"}
  @update_attrs %{archived_at: "2023-01-30T23:57:00", name: "some updated name"}
  @invalid_attrs %{archived_at: nil, name: nil}

  defp create_inventory_pool(_) do
    inventory_pool = inventory_pool_fixture()
    %{inventory_pool: inventory_pool}
  end

  describe "Index" do
    setup [:create_inventory_pool]

    test "lists all inventory_pools", %{conn: conn, inventory_pool: inventory_pool} do
      {:ok, _index_live, html} = live(conn, ~p"/inventory_pools")

      assert html =~ "Listing Inventory pools"
      assert html =~ inventory_pool.name
    end

    test "saves new inventory_pool", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/inventory_pools")

      assert index_live |> element("a", "New Inventory pool") |> render_click() =~
               "New Inventory pool"

      assert_patch(index_live, ~p"/inventory_pools/new")

      assert index_live
             |> form("#inventory_pool-form", inventory_pool: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#inventory_pool-form", inventory_pool: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/inventory_pools")

      assert html =~ "Inventory pool created successfully"
      assert html =~ "some name"
    end

    test "updates inventory_pool in listing", %{conn: conn, inventory_pool: inventory_pool} do
      {:ok, index_live, _html} = live(conn, ~p"/inventory_pools")

      assert index_live |> element("#inventory_pools-#{inventory_pool.id} a", "Edit") |> render_click() =~
               "Edit Inventory pool"

      assert_patch(index_live, ~p"/inventory_pools/#{inventory_pool}/edit")

      assert index_live
             |> form("#inventory_pool-form", inventory_pool: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#inventory_pool-form", inventory_pool: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/inventory_pools")

      assert html =~ "Inventory pool updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes inventory_pool in listing", %{conn: conn, inventory_pool: inventory_pool} do
      {:ok, index_live, _html} = live(conn, ~p"/inventory_pools")

      assert index_live |> element("#inventory_pools-#{inventory_pool.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#inventory_pool-#{inventory_pool.id}")
    end
  end

  describe "Show" do
    setup [:create_inventory_pool]

    test "displays inventory_pool", %{conn: conn, inventory_pool: inventory_pool} do
      {:ok, _show_live, html} = live(conn, ~p"/inventory_pools/#{inventory_pool}")

      assert html =~ "Show Inventory pool"
      assert html =~ inventory_pool.name
    end

    test "updates inventory_pool within modal", %{conn: conn, inventory_pool: inventory_pool} do
      {:ok, show_live, _html} = live(conn, ~p"/inventory_pools/#{inventory_pool}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Inventory pool"

      assert_patch(show_live, ~p"/inventory_pools/#{inventory_pool}/show/edit")

      assert show_live
             |> form("#inventory_pool-form", inventory_pool: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#inventory_pool-form", inventory_pool: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/inventory_pools/#{inventory_pool}")

      assert html =~ "Inventory pool updated successfully"
      assert html =~ "some updated name"
    end
  end
end
