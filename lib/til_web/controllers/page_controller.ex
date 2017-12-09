defmodule TilWeb.PageController do
  use TilWeb, :controller

  import TilWeb.LayoutView, only: [user_signed_in?: 1]

  def index(conn, _params) do
    if user_signed_in?(conn) do
      redirect(conn, to: "/dash/")
    else
      render(conn, "index.html")
    end
  end

  def github_access_notice(conn, _params) do
    render(conn, [])
  end
end
