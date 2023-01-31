defmodule RepositoryWeb.ItemLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Accounts.Organization
  alias Repository.Materials
  alias Repository.Materials.Item

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:items, list_items(organization))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Materials.get_item!(socket.assigns.organization, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Materials.get_item!(socket.assigns.organization, id)
    {:ok, _} = Materials.delete_item(item)

    {:noreply, assign(socket, :items, list_items(socket.assigns.organization))}
  end

  defp list_items(%Organization{} = organization) do
    organization
    |> Materials.list_items()
    |> Repository.Repo.preload(:item_category)
  end
end
