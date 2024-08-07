defmodule BookSearch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BookSearchWeb.Telemetry,
      BookSearch.Repo,
      {DNSCluster, query: Application.get_env(:book_search, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BookSearch.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BookSearch.Finch},
      # Start a worker by calling: BookSearch.Worker.start_link(arg)
      # {BookSearch.Worker, arg},
      # Start to serve requests, typically the last entry
      BookSearchWeb.Endpoint,
      {Nx.Serving,
       serving: BookSearch.Model.serving(defn_options: [compiler: EXLA]),
       batch_size: 16,
       batch_timeout: 100, # ms.
       name: BookSearchModel}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BookSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookSearchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
