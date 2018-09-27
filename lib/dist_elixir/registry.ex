defmodule DistElixir.Registry do
  use GenServer
  require Logger

  @name __MODULE__

  def start_link do
    IO.puts "starts the link here #{Node.self()}"
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def register(name) do
    GenServer.call(@name, {:register, name})
  end

  def monitor(pid, name) do
    GenServer.cast(@name, {:monitor, pid, name})
  end

  def init(_) do
    Process.send_after(self(), :log_state, 500)
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_cast({:monitor, pid, name}, state) do
    IO.puts "Name of registry #{name}"
    :pg2.create(DistElixir.pg2_group())
    :pg2.join(DistElixir.pg2_group(), pid)
    ref = Process.monitor(pid)
    {:noreply, Map.put(state, ref, name)}
  end

  def handle_call({:register, name}, _from, state) do
    IO.puts "Registering the new process"
    case start_via_swarm(name) do
      {:ok, pid} ->
        {:reply, {:ok, pid}, state}
      {:already_registered, pid} ->
        {:reply, {:ok, pid}, state}
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  def handle_info(:log_state, state) do
    total = Swarm.registered() |> Enum.count()
    local = state |>  Enum.count()
    Logger.debug("[Registry] Totals:  Swarm/#{total} Local/#{local}")
    Process.send_after(self(), :log_state, 500)
    {:noreply, state}
  end

  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    {:noreply, Map.delete(state, ref)}
  end

  def handle_info({:DOWN, ref, :process, _pid, :shutdown}, state) do
    {:noreply, Map.delete(state, ref)}
  end

  def handle_info({:DOWN, ref, :process, _pid, reason}, state) do
    case Map.get(state, ref) do
      nil ->
        {:noreply, state}
      name ->
        {:ok, _pid} = start_via_swarm(name, "restarting from swarm")
        {:noreply, Map.delete(state, ref)}
    end
  end

  def start_via_swarm(name, reason \\ "starting") do
    Logger.debug("[Registry] #{reason} #{name}")
    Swarm.register_name(name, DistElixir.Worker, :register, [name])
  end
end
