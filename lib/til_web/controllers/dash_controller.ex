defmodule TilWeb.DashController do
  use TilWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end

