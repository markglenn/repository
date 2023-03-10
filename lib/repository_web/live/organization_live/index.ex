defmodule RepositoryWeb.OrganizationLive.Index do
  use RepositoryWeb, :live_view

  alias Repository.Accounts
  alias Repository.Accounts.Organization

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :organizations, list_organizations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Organization")
    |> assign(:organization, Accounts.get_organization!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Organization")
    |> assign(:organization, %Organization{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Organizations")
    |> assign(:organization, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = Accounts.get_organization!(id)
    {:ok, _} = Accounts.delete_organization(organization)

    {:noreply, assign(socket, :organizations, list_organizations())}
  end

  defp list_organizations do
    Accounts.list_organizations()
  end
end
