defmodule RepositoryWeb.ItemCategoryLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Accounts.Organization
  alias Repository.Materials
  alias Repository.Materials.ItemCategory

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:item_categories, list_item_categories(organization))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item category")
    |> assign(:item_category, Materials.get_item_category!(socket.assigns.organization, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item category")
    |> assign(:item_category, %ItemCategory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Item categories")
    |> assign(:item_category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item_category = Materials.get_item_category!(socket.assigns.organization, id)
    {:ok, _} = Materials.delete_item_category(item_category)

    {:noreply,
     assign(socket, :item_categories, list_item_categories(socket.assigns.organization))}
  end

  defp list_item_categories(%Organization{} = organization) do
    Materials.list_item_categories(organization)
  end
end
