defmodule Ga.Mixfile do
  use Mix.Project

  def project do
    [app: :ga,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
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
      {:problem, git: "https://github.com/KiyoMenager/problem.git"},
      {:toroidal_grid, git: "https://github.com/KiyoMenager/toroidal_grid.git"},
      # {:distance_matrix, git: "https://github.com/KiyoMenager/distance_matrix.git"}
    ]
  end
end
