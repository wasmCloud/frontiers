defmodule FrontiersSite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FrontiersSiteWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FrontiersSite.PubSub},
      # Start the Endpoint (http/https)
      FrontiersSiteWeb.Endpoint
      # Start a worker by calling: FrontiersSite.Worker.start_link(arg)
      # {FrontiersSite.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FrontiersSite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FrontiersSiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
