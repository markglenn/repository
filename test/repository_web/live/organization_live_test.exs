defmodule RepositoryWeb.OrganizationLiveTest do
  use RepositoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Repository.AccountsFixtures

  @create_attrs %{archived_at: "2023-01-29T22:20:00", name: "some name"}
  @update_attrs %{archived_at: "2023-01-30T22:20:00", name: "some updated name"}
  @invalid_attrs %{archived_at: nil, name: nil}

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end

  describe "Index" do
    setup [:create_organization]

    test "lists all organizations", %{conn: conn, organization: organization} do
      {:ok, _index_live, html} = live(conn, ~p"/organizations")

      assert html =~ "Listing Organizations"
      assert html =~ organization.name
    end

    test "saves new organization", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/organizations")

      assert index_live |> element("a", "New Organization") |> render_click() =~
               "New Organization"

      assert_patch(index_live, ~p"/organizations/new")

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organization-form", organization: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/organizations")

      assert html =~ "Organization created successfully"
      assert html =~ "some name"
    end

    test "updates organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, ~p"/organizations")

      assert index_live |> element("#organizations-#{organization.id} a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(index_live, ~p"/organizations/#{organization}/edit")

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organization-form", organization: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/organizations")

      assert html =~ "Organization updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, ~p"/organizations")

      assert index_live |> element("#organizations-#{organization.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#organization-#{organization.id}")
    end
  end

  describe "Show" do
    setup [:create_organization]

    test "displays organization", %{conn: conn, organization: organization} do
      {:ok, _show_live, html} = live(conn, ~p"/organizations/#{organization}")

      assert html =~ "Show Organization"
      assert html =~ organization.name
    end

    test "updates organization within modal", %{conn: conn, organization: organization} do
      {:ok, show_live, _html} = live(conn, ~p"/organizations/#{organization}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(show_live, ~p"/organizations/#{organization}/show/edit")

      assert show_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#organization-form", organization: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/organizations/#{organization}")

      assert html =~ "Organization updated successfully"
      assert html =~ "some updated name"
    end
  end
end
