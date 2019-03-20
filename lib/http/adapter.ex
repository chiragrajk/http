defmodule Http.PlugAdapter do
  def dispatch(request, plug) do
    %Plug.Conn{
      adapter: {Http.PlugAdapter, request},
      owner: self()
    } 
    |> plug.call([])
  end
  
  def send_resp(socket, status, headers, body) do
    response = "HTTP/1.1 #{status}\r\n#{headers(headers)}\r\n#{body}"
    
    Http.send_response(socket, response)
    {:ok, nil, socket}
  end

  def child_spec(plug: plug, port: port) do
    Http.child_spec(port: port, dispatch: &dispatch(&1, plug))
  end

  def headers(headers) do
    Enum.reduce(headers, "", fn ({key, value}, acc) -> 
      acc <> key <> ": " <> value <> "\r\n"
    end)
  end
end