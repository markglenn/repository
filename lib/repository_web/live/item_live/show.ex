defmodule RepositoryWeb.ItemLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Materials

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok,
     socket
     |> assign(:organization, organization)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    item =
      Materials.get_item!(socket.assigns.organization, id)
      |> Repository.Repo.preload(:item_category)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:item, item)}
  end

  defp page_title(:show), do: "Show Item"
  defp page_title(:edit), do: "Edit Item"
end
