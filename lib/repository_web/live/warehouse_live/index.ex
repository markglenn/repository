defmodule RepositoryWeb.WarehouseLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Accounts.Organization
  alias Repository.Inventories
  alias Repository.Inventories.Warehouse

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok,
     socket
     |> assign(:warehouses, list_warehouses(organization))
     |> assign(:organization, organization)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Warehouse")
    |> assign(:warehouse, Inventories.get_warehouse!(socket.assigns.organization, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Warehouse")
    |> assign(:warehouse, %Warehouse{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Warehouses")
    |> assign(:warehouse, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    warehouse = Inventories.get_warehouse!(socket.assigns.organization, id)
    {:ok, _} = Inventories.delete_warehouse(warehouse)

    {:noreply, assign(socket, :warehouses, list_warehouses(socket.assigns.organization))}
  end

  defp list_warehouses(%Organization{} = organization) do
    Inventories.list_warehouses(organization)
  end
end
