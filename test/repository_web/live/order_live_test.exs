defmodule RepositoryWeb.OrderLiveTest do
  use RepositoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Repository.FulfillmentFixtures

  @create_attrs %{archived_at: "2023-02-01T00:12:00", fulfilled_at: "2023-02-01T00:12:00", reference_id: "some reference_id"}
  @update_attrs %{archived_at: "2023-02-02T00:12:00", fulfilled_at: "2023-02-02T00:12:00", reference_id: "some updated reference_id"}
  @invalid_attrs %{archived_at: nil, fulfilled_at: nil, reference_id: nil}

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:create_order]

    test "lists all orders", %{conn: conn, order: order} do
      {:ok, _index_live, html} = live(conn, ~p"/orders")

      assert html =~ "Listing Orders"
      assert html =~ order.reference_id
    end

    test "saves new order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("a", "New Order") |> render_click() =~
               "New Order"

      assert_patch(index_live, ~p"/orders/new")

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/orders")

      assert html =~ "Order created successfully"
      assert html =~ "some reference_id"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("#orders-#{order.id} a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(index_live, ~p"/orders/#{order}/edit")

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/orders")

      assert html =~ "Order updated successfully"
      assert html =~ "some updated reference_id"
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("#orders-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#order-#{order.id}")
    end
  end

  describe "Show" do
    setup [:create_order]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, ~p"/orders/#{order}")

      assert html =~ "Show Order"
      assert html =~ order.reference_id
    end

    test "updates order within modal", %{conn: conn, order: order} do
      {:ok, show_live, _html} = live(conn, ~p"/orders/#{order}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(show_live, ~p"/orders/#{order}/show/edit")

      assert show_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/orders/#{order}")

      assert html =~ "Order updated successfully"
      assert html =~ "some updated reference_id"
    end
  end
end
