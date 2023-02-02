defmodule RepositoryWeb.OrderLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Fulfillment

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
     |> assign(:order, Fulfillment.get_order!(socket.assigns.organization, id))}
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
