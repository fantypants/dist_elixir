defmodule DistElixir.Router do
  use Plug.Router
    require Logger

    plug Plug.Logger
    plug :match
    plug :dispatch

    def init(options) do
      options
    end

    def start_link do
      case Plug.Adapters.Cowboy.http DistElixir.Router, [], port: 8888 do
        {:ok, _} ->
          IO.puts "started correctly"
        {:error, _} ->
          IO.puts "Error currently in use, Will become Available when the owner process dies"
      end
    end

    get "/" do
      conn
      |> send_resp(200, "Iam Server #{Node.self()}")
      |> halt
    end
end
