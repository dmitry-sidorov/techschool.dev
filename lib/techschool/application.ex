defmodule Techschool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Run migrations
    Techschool.Release.migrate()

    children = [
      TechschoolWeb.Telemetry,
      Techschool.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:techschool, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:techschool, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Techschool.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Techschool.Finch},
      # Start a worker by calling: Techschool.Worker.start_link(arg)
      # {Techschool.Worker, arg},
      # Start to serve requests, typically the last entry
      TechschoolWeb.Presence,
      TechschoolWeb.Endpoint,
      {Cachex, name: :techschool_cache},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Techschool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TechschoolWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
