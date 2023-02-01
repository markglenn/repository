defmodule RepositoryWeb.WarehouseLive.FormComponent do
  use RepositoryWeb, :live_component

  alias Repository.Inventories

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage warehouse records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="warehouse-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Warehouse</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{warehouse: warehouse} = assigns, socket) do
    changeset = Inventories.change_warehouse(warehouse)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"warehouse" => warehouse_params}, socket) do
    changeset =
      socket.assigns.warehouse
      |> Inventories.change_warehouse(warehouse_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"warehouse" => warehouse_params}, socket) do
    save_warehouse(socket, socket.assigns.action, warehouse_params)
  end

  defp save_warehouse(socket, :edit, warehouse_params) do
    case Inventories.update_warehouse(socket.assigns.warehouse, warehouse_params) do
      {:ok, _warehouse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Warehouse updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_warehouse(socket, :new, warehouse_params) do
    case Inventories.create_warehouse(socket.assigns.organization, warehouse_params) do
      {:ok, _warehouse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Warehouse created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
