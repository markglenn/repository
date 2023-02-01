defmodule RepositoryWeb.WarehouseLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Inventories

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :organization, Accounts.get_organization!(params["organization_id"]))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:warehouse, Inventories.get_warehouse!(socket.assigns.organization, id))}
  end

  defp page_title(:show), do: "Show Warehouse"
  defp page_title(:edit), do: "Edit Warehouse"
end
