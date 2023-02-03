defmodule RepositoryWeb.AllocationLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Fulfillment
  alias Repository.Fulfillment.OrderLine
  alias Repository.Fulfillment.Allocation

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])
    order = Fulfillment.get_order!(organization, params["order_id"])
    order_line = Fulfillment.get_order_line!(order, params["order_line_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:order, order)
     |> assign(:order_line, order_line)
     |> assign(:allocations, list_allocations(order_line))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Allocation")
    |> assign(:allocation, Fulfillment.get_allocation!(socket.assigns.order_line, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Allocation")
    |> assign(:allocation, %Allocation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Allocations")
    |> assign(:allocation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    allocation = Fulfillment.get_allocation!(socket.assigns.order_line, id)
    {:ok, _} = Fulfillment.delete_allocation(allocation)

    {:noreply, assign(socket, :allocations, list_allocations(socket.assigns.order_line))}
  end

  defp list_allocations(%OrderLine{} = order_line) do
    Fulfillment.list_allocations(order_line)
  end
end
