defmodule RepositoryWeb.OrderLineLive.FormComponent do
  use RepositoryWeb, :live_component

  alias Repository.Accounts.Organization
  alias Repository.Inventories
  alias Repository.Materials

  alias Repository.Fulfillment

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage order_line records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="order_line-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :reference_id}} type="text" label="Reference" />
        <.input field={{f, :quantity}} type="number" label="Quantity" step="any" />
        <.input field={{f, :item_id}} type="select" label="Item" options={@items} />
        <.input field={{f, :inventory_pool_id}} type="select" label="Inventory Pool" options={@inventory_pools} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Order line</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{order_line: order_line} = assigns, socket) do
    changeset = Fulfillment.change_order_line(order_line)
    inventory_pools = get_inventory_pools(assigns.organization)
    items = get_items(assigns.organization)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:items, items)
     |> assign(:inventory_pools, inventory_pools)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"order_line" => order_line_params}, socket) do
    changeset =
      socket.assigns.order_line
      |> Fulfillment.change_order_line(order_line_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"order_line" => order_line_params}, socket) do
    save_order_line(socket, socket.assigns.action, order_line_params)
  end

  defp save_order_line(socket, :edit, order_line_params) do
    case Fulfillment.update_order_line(socket.assigns.order_line, order_line_params) do
      {:ok, _order_line} ->
        {:noreply,
         socket
         |> put_flash(:info, "Order line updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_order_line(socket, :new, order_line_params) do
    case Fulfillment.create_order_line(socket.assigns.order, order_line_params) do
      {:ok, _order_line} ->
        {:noreply,
         socket
         |> put_flash(:info, "Order line created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
        |> IO.inspect()
    end
  end

  defp get_inventory_pools(%Organization{} = organization) do
    organization
    |> Inventories.list_inventory_pools()
    |> Enum.map(&{&1.name, &1.id})
  end

  defp get_items(%Organization{} = organization) do
    organization
    |> Materials.list_items()
    |> Enum.map(&{&1.name, &1.id})
  end
end
