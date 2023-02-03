defmodule RepositoryWeb.AllocationLiveTest do
  use RepositoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Repository.FulfillmentFixtures

  @create_attrs %{quantity: "120.5"}
  @update_attrs %{quantity: "456.7"}
  @invalid_attrs %{quantity: nil}

  defp create_allocation(_) do
    allocation = allocation_fixture()
    %{allocation: allocation}
  end

  describe "Index" do
    setup [:create_allocation]

    test "lists all allocations", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/allocations")

      assert html =~ "Listing Allocations"
    end

    test "saves new allocation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/allocations")

      assert index_live |> element("a", "New Allocation") |> render_click() =~
               "New Allocation"

      assert_patch(index_live, ~p"/allocations/new")

      assert index_live
             |> form("#allocation-form", allocation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#allocation-form", allocation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/allocations")

      assert html =~ "Allocation created successfully"
    end

    test "updates allocation in listing", %{conn: conn, allocation: allocation} do
      {:ok, index_live, _html} = live(conn, ~p"/allocations")

      assert index_live |> element("#allocations-#{allocation.id} a", "Edit") |> render_click() =~
               "Edit Allocation"

      assert_patch(index_live, ~p"/allocations/#{allocation}/edit")

      assert index_live
             |> form("#allocation-form", allocation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#allocation-form", allocation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/allocations")

      assert html =~ "Allocation updated successfully"
    end

    test "deletes allocation in listing", %{conn: conn, allocation: allocation} do
      {:ok, index_live, _html} = live(conn, ~p"/allocations")

      assert index_live |> element("#allocations-#{allocation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#allocation-#{allocation.id}")
    end
  end

  describe "Show" do
    setup [:create_allocation]

    test "displays allocation", %{conn: conn, allocation: allocation} do
      {:ok, _show_live, html} = live(conn, ~p"/allocations/#{allocation}")

      assert html =~ "Show Allocation"
    end

    test "updates allocation within modal", %{conn: conn, allocation: allocation} do
      {:ok, show_live, _html} = live(conn, ~p"/allocations/#{allocation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Allocation"

      assert_patch(show_live, ~p"/allocations/#{allocation}/show/edit")

      assert show_live
             |> form("#allocation-form", allocation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#allocation-form", allocation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/allocations/#{allocation}")

      assert html =~ "Allocation updated successfully"
    end
  end
end
