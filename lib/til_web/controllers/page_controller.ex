defmodule TilWeb.PageController do
  use TilWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def github_access_notice(conn, _params) do
    render conn, "index.html"
  end
end
