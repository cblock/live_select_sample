defmodule LiveSelectSample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveSelectSampleWeb.Telemetry,
      # Start the Ecto repository
      LiveSelectSample.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveSelectSample.PubSub},
      # Start Finch
      {Finch, name: LiveSelectSample.Finch},
      # Start the Endpoint (http/https)
      LiveSelectSampleWeb.Endpoint
      # Start a worker by calling: LiveSelectSample.Worker.start_link(arg)
      # {LiveSelectSample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveSelectSample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveSelectSampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
