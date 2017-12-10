defmodule TilWeb.DashController do
  use TilWeb, :controller

  def index(conn, _params) do
    posts = Repository.posts_for(conn.assigns[:current_user])
    posts = Enum.flat_map(1..12, fn _ -> posts end)
    render(conn, posts: posts)
  end
end
