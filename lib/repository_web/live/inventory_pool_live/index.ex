defmodule RepositoryWeb.InventoryPoolLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Inventories
  alias Repository.Inventories.InventoryPool

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:inventory_pools, list_inventory_pools(organization))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Inventory pool")
    |> assign(:inventory_pool, Inventories.get_inventory_pool!(socket.assigns.organization, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Inventory pool")
    |> assign(:inventory_pool, %InventoryPool{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Inventory pools")
    |> assign(:inventory_pool, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = socket.assigns.organization
    inventory_pool = Inventories.get_inventory_pool!(organization, id)
    {:ok, _} = Inventories.delete_inventory_pool(inventory_pool)

    {:noreply, assign(socket, :inventory_pools, list_inventory_pools(organization))}
  end

  defp list_inventory_pools(organization) do
    Inventories.list_inventory_pools(organization)
  end
end
