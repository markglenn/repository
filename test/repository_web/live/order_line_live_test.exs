defmodule RepositoryWeb.OrderLineLiveTest do
  use RepositoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Repository.FulfillmentFixtures

  @create_attrs %{quantity: "120.5", reference_id: "some reference_id"}
  @update_attrs %{quantity: "456.7", reference_id: "some updated reference_id"}
  @invalid_attrs %{quantity: nil, reference_id: nil}

  defp create_order_line(_) do
    order_line = order_line_fixture()
    %{order_line: order_line}
  end

  describe "Index" do
    setup [:create_order_line]

    test "lists all order_lines", %{conn: conn, order_line: order_line} do
      {:ok, _index_live, html} = live(conn, ~p"/order_lines")

      assert html =~ "Listing Order lines"
      assert html =~ order_line.reference_id
    end

    test "saves new order_line", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/order_lines")

      assert index_live |> element("a", "New Order line") |> render_click() =~
               "New Order line"

      assert_patch(index_live, ~p"/order_lines/new")

      assert index_live
             |> form("#order_line-form", order_line: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order_line-form", order_line: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/order_lines")

      assert html =~ "Order line created successfully"
      assert html =~ "some reference_id"
    end

    test "updates order_line in listing", %{conn: conn, order_line: order_line} do
      {:ok, index_live, _html} = live(conn, ~p"/order_lines")

      assert index_live |> element("#order_lines-#{order_line.id} a", "Edit") |> render_click() =~
               "Edit Order line"

      assert_patch(index_live, ~p"/order_lines/#{order_line}/edit")

      assert index_live
             |> form("#order_line-form", order_line: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order_line-form", order_line: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/order_lines")

      assert html =~ "Order line updated successfully"
      assert html =~ "some updated reference_id"
    end

    test "deletes order_line in listing", %{conn: conn, order_line: order_line} do
      {:ok, index_live, _html} = live(conn, ~p"/order_lines")

      assert index_live |> element("#order_lines-#{order_line.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#order_line-#{order_line.id}")
    end
  end

  describe "Show" do
    setup [:create_order_line]

    test "displays order_line", %{conn: conn, order_line: order_line} do
      {:ok, _show_live, html} = live(conn, ~p"/order_lines/#{order_line}")

      assert html =~ "Show Order line"
      assert html =~ order_line.reference_id
    end

    test "updates order_line within modal", %{conn: conn, order_line: order_line} do
      {:ok, show_live, _html} = live(conn, ~p"/order_lines/#{order_line}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order line"

      assert_patch(show_live, ~p"/order_lines/#{order_line}/show/edit")

      assert show_live
             |> form("#order_line-form", order_line: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#order_line-form", order_line: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/order_lines/#{order_line}")

      assert html =~ "Order line updated successfully"
      assert html =~ "some updated reference_id"
    end
  end
end
