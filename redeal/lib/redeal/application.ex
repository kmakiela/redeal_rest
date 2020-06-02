defmodule Redeal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RedealWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Redeal.PubSub},
      # Start the Endpoint (http/https)
      RedealWeb.Endpoint,
      # Start a worker by calling: Redeal.Worker.start_link(arg)
      # {Redeal.Worker, arg}

      # rabbitmq connection handler
      Redeal.RabbitHandler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Redeal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RedealWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
