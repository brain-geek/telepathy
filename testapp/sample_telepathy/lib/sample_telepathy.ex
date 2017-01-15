defmodule SampleTelepathy do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SampleTelepathy.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SampleTelepathy.Endpoint, []),

      worker(SampleTelepathy.CitiesListener, [Application.get_env(:sample_telepathy, SampleTelepathy.Repo)]),

      worker(SampleTelepathy.CitiesDeleteListener, [Application.get_env(:sample_telepathy, SampleTelepathy.Repo)]),
      worker(SampleTelepathy.CitiesInsertListener, [Application.get_env(:sample_telepathy, SampleTelepathy.Repo)]),
      worker(SampleTelepathy.CitiesUpdateListener, [Application.get_env(:sample_telepathy, SampleTelepathy.Repo)]),

      worker(SampleTelepathy.CitiesListenerAgent, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SampleTelepathy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SampleTelepathy.Endpoint.config_change(changed, removed)
    :ok
  end
end
