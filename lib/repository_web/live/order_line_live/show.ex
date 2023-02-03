defmodule RepositoryWeb.OrderLineLive.Show do
  use RepositoryWeb, :live_view

  alias Repository.Fulfillment
  alias Repository.Accounts

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])
    order = Fulfillment.get_order!(organization, params["order_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:order, order)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :order_line,
       Fulfillment.get_order_line!(socket.assigns.order, id, preload: [:item, :inventory_pool])
     )}
  end

  defp page_title(:show), do: "Show Order line"
  defp page_title(:edit), do: "Edit Order line"
end
