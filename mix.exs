defmodule ChromeRemoteInterface.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chrome_remote_interface,
      version: "0.4.2",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Chrome Remote Interface",
      source_url: "https://github.com/jeffh/chrome-remote-interface",
      description: description(),
      package: package()
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
      {:jason, "~> 1.4"},
      {:hackney, "~> 1.20"},
      {:websockex, "~> 0.4.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Chrome Debugging Protocol client for Elixir"
  end

  defp package do
    [
      maintainers: ["jeff@jeffhui.net"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/jeffh/chrome-remote-interface"
      }
    ]
  end
end
