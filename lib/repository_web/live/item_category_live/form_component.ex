defmodule RepositoryWeb.ItemCategoryLive.FormComponent do
  use RepositoryWeb, :live_component

  alias Repository.Materials

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage item_category records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="item_category-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Item category</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{item_category: item_category} = assigns, socket) do
    changeset = Materials.change_item_category(item_category)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"item_category" => item_category_params}, socket) do
    changeset =
      socket.assigns.item_category
      |> Materials.change_item_category(item_category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"item_category" => item_category_params}, socket) do
    save_item_category(socket, socket.assigns.action, item_category_params)
  end

  defp save_item_category(socket, :edit, item_category_params) do
    case Materials.update_item_category(socket.assigns.item_category, item_category_params) do
      {:ok, _item_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item category updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_item_category(socket, :new, item_category_params) do
    IO.inspect(socket)

    case Materials.create_item_category(socket.assigns.organization, item_category_params) do
      {:ok, _item_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item category created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
