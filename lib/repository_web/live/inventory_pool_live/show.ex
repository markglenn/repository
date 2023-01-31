defmodule RepositoryWeb.InventoryPoolLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Inventories

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok, assign(socket, :organization, organization)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:inventory_pool, Inventories.get_inventory_pool!(socket.assigns.organization, id))}
  end

  defp page_title(:show), do: "Show Inventory pool"
  defp page_title(:edit), do: "Edit Inventory pool"
end
