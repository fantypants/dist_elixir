defmodule Leader.Mixfile do
  use Mix.Project

  def project do
    [app: :distelixir,
     version: "0.1.0",
     elixir: "~> 1.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :libcluster, :swarm],
     mod: {DistElixir, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:libcluster, ">= 0.0.0"},
      {:swarm, ">= 0.0.0"},
      {:socket, "~> 0.3"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.5"},
      {:poison, "~> 3.1"}
    ]
  end
end
