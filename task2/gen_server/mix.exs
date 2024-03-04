defmodule ChatApp90s.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_app_90s,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [ ]
  end
end
