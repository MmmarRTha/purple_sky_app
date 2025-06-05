defmodule PurpleSkyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PurpleSkyAppWeb.Telemetry,
      PurpleSkyApp.Repo,
      {DNSCluster, query: Application.get_env(:purple_sky_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PurpleSkyApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PurpleSkyApp.Finch},
      # Start a worker by calling: PurpleSkyApp.Worker.start_link(arg)
      # {PurpleSkyApp.Worker, arg},
      # Start to serve requests, typically the last entry
      PurpleSkyAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PurpleSkyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PurpleSkyAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
