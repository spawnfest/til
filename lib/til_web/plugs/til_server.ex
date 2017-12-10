defmodule TilWeb.Plugs.TilServerPlug do
  import Plug.Conn
  alias Til.Repo
  alias Til.Repository.Post
  import Ecto.Query
  alias Til.Accounts.User
  alias TilWeb.Views.TilServerView

  def init(opts), do: opts

  def call(conn, _opts) do
    # get subdomain
    with {:ok, user} <- get_user(conn),
         # get path
         {:ok, path} <- get_path(conn) do
      render_post(conn, user, path)
    end
  end

  # render home page
  defp render_post(conn, user, "") do
    posts =
      from(p in Post, where: p.user_id == ^user.id, order_by: [desc: p.inserted_at], limit: 10)
      |> Repo.all()

    {:safe, iodata} = Phoenix.View.render(TilServerView, "index.html", posts: posts, user: user)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(:ok, iodata)
  end

  # render home page
  defp render_post(conn, user, path) do
    # find the til
    with {:ok, post} <- get_post(user, path) do
      {:safe, iodata} = Phoenix.View.render(TilServerView, "post.html", post: post, user: user)
      # render it
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(:ok, iodata)
    end
  end

  @host_suffix ".#{Application.get_env(:til, :host)}"
  defp get_user(conn) do
    subdomain = conn.host |> to_string |> String.replace_suffix(@host_suffix, "")

    case Repo.all(from(u in User, where: u.github_username == ^subdomain)) do
      [user] -> {:ok, user}
      _ -> :site_not_found
    end
  end

  defp get_path(conn),
    do:
      {
        :ok,
        conn.path_info
        |> Enum.join("/")
        |> String.replace_suffix("/", "")
      }

  defp get_post(user, path) do
    path = path <> ".md"

    case from(p in Post, where: p.path == ^path and p.user_id == ^user.id)
         |> Repo.all() do
      [] -> :post_not_found
      [post] -> {:ok, post}
    end
  end
end
