defmodule Excoap.Mixfile do
  use Mix.Project

  def project do
    [app: :excoap,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp description do
    """
    CoAP implementation for Elixir
    """
  end

  defp package do
    [contributors: ["Marcin Białoń"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mbialon/excoap"}]
  end
end
