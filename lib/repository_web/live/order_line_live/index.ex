defmodule RepositoryWeb.OrderLineLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Fulfillment
  alias Repository.Fulfillment.{Order, OrderLine}

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])
    order = Fulfillment.get_order!(organization, params["order_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:order, order)
     |> assign(:order_lines, list_order_lines(order))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order line")
    |> assign(:order_line, Fulfillment.get_order_line!(socket.assigns.order, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order line")
    |> assign(:order_line, %OrderLine{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Order lines")
    |> assign(:order_line, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} =
      socket.assigns.order
      |> Fulfillment.get_order_line!(id)
      |> Fulfillment.delete_order_line()

    {:noreply, assign(socket, :order_lines, list_order_lines(socket.assigns.order))}
  end

  defp list_order_lines(%Order{} = order) do
    Fulfillment.list_order_lines(order, preload: [:item, :inventory_pool])
  end
end
