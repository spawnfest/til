defmodule TilWeb.DashController do
  use TilWeb, :controller

  def index(conn, _params) do
    posts = Repository.posts_for(conn.assigns[:current_user], 12)
    render(conn, posts: posts)
  end
end
