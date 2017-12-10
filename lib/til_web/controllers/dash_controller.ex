defmodule TilWeb.DashController do
  use TilWeb, :controller

  def index(conn, _params) do
    posts = Repository.posts_for(conn.assigns[:current_user])
    render(conn, posts: posts)
  end
end
