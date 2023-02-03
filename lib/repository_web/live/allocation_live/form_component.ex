defmodule RepositoryWeb.AllocationLive.FormComponent do
  use RepositoryWeb, :live_component

  alias Repository.Fulfillment

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage allocation records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="allocation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :quantity}} type="number" label="Quantity" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Allocation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{allocation: allocation} = assigns, socket) do
    changeset = Fulfillment.change_allocation(allocation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"allocation" => allocation_params}, socket) do
    changeset =
      socket.assigns.allocation
      |> Fulfillment.change_allocation(allocation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"allocation" => allocation_params}, socket) do
    save_allocation(socket, socket.assigns.action, allocation_params)
  end

  defp save_allocation(socket, :edit, allocation_params) do
    case Fulfillment.update_allocation(socket.assigns.allocation, allocation_params) do
      {:ok, _allocation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Allocation updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_allocation(socket, :new, allocation_params) do
    case Fulfillment.create_allocation(socket.assigns.order_line, allocation_params) do
      {:ok, _allocation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Allocation created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
