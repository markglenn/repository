defmodule RepositoryWeb.InventoryPoolLive.FormComponent do
  use RepositoryWeb, :live_component

  alias Repository.Inventories

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage inventory_pool records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="inventory_pool-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Inventory pool</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{inventory_pool: inventory_pool} = assigns, socket) do
    changeset = Inventories.change_inventory_pool(inventory_pool)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"inventory_pool" => inventory_pool_params}, socket) do
    changeset =
      socket.assigns.inventory_pool
      |> Inventories.change_inventory_pool(inventory_pool_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"inventory_pool" => inventory_pool_params}, socket) do
    save_inventory_pool(socket, socket.assigns.action, inventory_pool_params)
  end

  defp save_inventory_pool(socket, :edit, inventory_pool_params) do
    case Inventories.update_inventory_pool(socket.assigns.inventory_pool, inventory_pool_params) do
      {:ok, _inventory_pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Inventory pool updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_inventory_pool(socket, :new, inventory_pool_params) do
    case Inventories.create_inventory_pool(socket.assigns.organization, inventory_pool_params) do
      {:ok, _inventory_pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Inventory pool created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
