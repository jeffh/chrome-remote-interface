defmodule ChromeRemoteInterface.Websocket do
  require Logger

  use WebSockex

  def start_link(url) do
    WebSockex.start_link(url, __MODULE__, self())
  end

  def handle_frame({:text, frame_data}, state) do
    send(state, {:message, frame_data})
    {:ok, state}
  end

  def handle_info({:ssl_closed, _}, _state) do
    {:close, 0}
  end
end
