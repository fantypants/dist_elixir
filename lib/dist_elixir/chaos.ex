defmodule DistElixir.Chaos do
  use GenServer
  require Logger

  @start_delay Application.fetch_env!(:distelixir, :start_delay)
  @kill_delay Application.fetch_env!(:distelixir, :kill_delay)

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    #testing if when the conenction drops it resumes on the same connection
    Process.send_after(self(), :random_start, 1)
    Process.send_after(self(), :random_kill, @kill_delay)
    {:ok, :ok}
  end

  def handle_info(:random_start, state) do
    DistElixir.Registry.register(random_worker())
    Process.send_after(self(), :random_start, 1)
    {:noreply, state}
  end

  def handle_info(:random_kill, state) do
    case :pg2.get_local_members(DistElixir.pg2_group()) do
      [pid | _] when is_pid(pid) -> stop_server(pid)
      _ -> nil
    end

    Process.send_after(self(), :random_kill, @kill_delay)
    {:noreply, state}
  end

  defp random_worker, do: DistElixir.random_worker()

  defp stop_server(pid) do
    IO.puts "Server is stopping"
    {m, f, reason} = case :rand.uniform(5) do
      1 -> {GenServer, :stop, {:error, :rand_kill}}
      2 -> {GenServer, :stop, :normal}
      3 -> {GenServer, :stop, :shutdown}
      4 -> {DistElixir.Worker, :raise, "Triggered by DistElixir.Chaos"}
      5 -> {Process, :exit, {:error, :rand_kill}}
    end
    name = DistElixir.Worker.get_name(pid)
    #IO.puts "Exiting the Server"
    #Logger.error("[Chaos] stopping #{name} with: #{m}.#{f}(#{inspect(pid)}, #{inspect(reason)})")
    apply(m, f, [pid, reason])
  end
end
