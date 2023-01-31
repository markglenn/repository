defmodule RepositoryWeb.ItemCategoryLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Materials

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
     |> assign(:item_category, Materials.get_item_category!(socket.assigns.organization, id))}
  end

  defp page_title(:show), do: "Show Item category"
  defp page_title(:edit), do: "Edit Item category"
end
