defmodule Csp.MixProject do
  use Mix.Project

  def project do
    [
      app: :csp,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cspex, "~> 2.0.0-beta"}
    ]
  end
end
