defmodule MultiQueries.MixProject do
  use Mix.Project

  def project do
    [
      app: :multi_queries,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      mod: {MultiQueries.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:myxql, "~> 0.7.0"}
    ]
  end
end
