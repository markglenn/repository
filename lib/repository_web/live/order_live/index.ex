defmodule RepositoryWeb.OrderLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Accounts.Organization
  alias Repository.Fulfillment
  alias Repository.Fulfillment.Order

  @impl true
  def mount(params, _session, socket) do
    organization = Accounts.get_organization!(params["organization_id"])

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:orders, list_orders(organization))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Fulfillment.get_order!(socket.assigns.organization, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} =
      socket.assigns.organization
      |> Fulfillment.get_order!(id)
      |> Fulfillment.delete_order()

    {:noreply, assign(socket, :orders, list_orders(socket.assigns.organization))}
  end

  defp list_orders(%Organization{} = organization) do
    Fulfillment.list_orders(organization)
  end
end
