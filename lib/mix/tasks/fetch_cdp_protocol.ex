defmodule Mix.Tasks.FetchCdpProtocol do
  @moduledoc """
  Fetches up-to-date versions of all the Chrome Debugger Protocol files.

  These protocol files are stored in the private storage of this library.
  """

  use Mix.Task

  @shortdoc "Fetches up-to-date versions of all the Chrome Debugger Protocol files."

  @protocol_sources %{
    "1-2" => %{
      urls:
        ["https://raw.githubusercontent.com/ChromeDevTools/debugger-protocol-viewer/refs/heads/master/pages/_data/1-2.json"],
      output: "priv/1-2/protocol.json"
    },
    "1-3" => %{
      urls:
        ["https://raw.githubusercontent.com/ChromeDevTools/debugger-protocol-viewer/refs/heads/master/pages/_data/1-3.json"],
      output: "priv/1-3/protocol.json"
    },
    "tot" => %{
      urls:
        [
          "https://raw.githubusercontent.com/ChromeDevTools/devtools-protocol/refs/heads/master/json/browser_protocol.json",
          "https://raw.githubusercontent.com/ChromeDevTools/devtools-protocol/refs/heads/master/json/js_protocol.json",
        ],
      output: "priv/tot/protocol.json"
    }
  }

  @impl true
  def run(_) do
    Application.ensure_all_started(:hackney)
    Application.ensure_all_started(:jason)
    Map.keys(@protocol_sources)
    |> Enum.each(&fetch_protocol/1)
  end

  def fetch_protocol(version) do
    protocol_source = Map.fetch!(@protocol_sources, version)

    specs = protocol_source.urls
    |> Stream.map(fn url ->
        with {:ok, 200, _, client_ref} <- :hackney.request(:get, url, [], <<>>, []),
             {:ok, body} <- :hackney.body(client_ref),
             {:ok, parsed_body} <- Jason.decode(body) do
          parsed_body
        else
          error -> raise "failed to fetch: #{inspect(error)}"
        end
    end)

    [spec] = Enum.take(specs, 1)

    additional_domains = specs
      |> Stream.drop(1)
      |> Stream.flat_map(fn other_spec -> other_spec["domains"] end)

    spec = %{spec | "domains" => Enum.concat(spec["domains"], additional_domains)}
    File.write!(protocol_source.output, Jason.encode!(spec, pretty: true))
  end
end
