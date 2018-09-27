defmodule DistElixir do
  use Application

  @pg2_group :distelixir_workers
  @workers Application.fetch_env!(:distelixir, :workers)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(DistElixir.Registry, []),
      worker(DistElixir.Chaos, []),
      supervisor(Task.Supervisor, [[name: DistElixir.TaskSupervisor]])

    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def pg2_group, do: @pg2_group
  def random_worker, do: :"worker_#{:rand.uniform(@workers)}"
end
