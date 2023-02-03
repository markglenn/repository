defmodule RepositoryWeb.AllocationLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Fulfillment

  alias Repository.Accounts

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])
    order = Fulfillment.get_order!(organization, params["order_id"])
    order_line = Fulfillment.get_order_line!(order, params["order_line_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:order, order)
     |> assign(:order_line, order_line)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:allocation, Fulfillment.get_allocation!(socket.assigns.order_line, id))}
  end

  defp page_title(:show), do: "Show Allocation"
  defp page_title(:edit), do: "Edit Allocation"
end
