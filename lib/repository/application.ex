defmodule Repository.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RepositoryWeb.Telemetry,
      # Start the Ecto repository
      Repository.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Repository.PubSub},
      # Start Finch
      {Finch, name: Repository.Finch},
      # Start the Endpoint (http/https)
      RepositoryWeb.Endpoint
      # Start a worker by calling: Repository.Worker.start_link(arg)
      # {Repository.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Repository.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RepositoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
