defmodule CurrentTime do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "hello world! the time is #{Time.to_string(Time.utc_now)}")
  end
end