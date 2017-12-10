defmodule TilWeb.Plugs.TilServerPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Til.Repo
  alias Til.Repository.Post
  import Ecto.Query
  alias Til.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    # get subdomain
    with {:ok, user_id} <- get_user(conn),
         # get path
         {:ok, path} <- get_path(conn) do
      render_post(conn, user_id, path)
    end
  end

  # render home page
  defp render_post(conn, user_id, "") do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(:ok, "<!doctype html><h1>Home Page</h1>")
  end

  # render home page
  defp render_post(conn, user_id, path) do
    # find the til
    with {:ok, post} <- get_post(user_id, path) do
      # render it
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(:ok, """
         <!doctype html>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/monokai.min.css" />
         <style>
          pre{
            margin: 5px 0;
          }
         </style>
         <body><h1>#{post.title}</h1>#{markdown_to_html(post.body)}</body>
         <script charset="utf-8" src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"></script>
         <script charset="utf-8">hljs.initHighlightingOnLoad()</script>
         """)
    end
  end

  defp markdown_to_html(body) do
    {:ok, html, []} =
      Earmark.as_html(body, %Earmark.Options{
        gfm: true,
        breaks: false
      })

    html
  end

  @host_suffix ".#{Application.get_env(:til, :host)}"
  defp get_user(conn) do
    subdomain = conn.host |> to_string |> String.replace_suffix(@host_suffix, "")

    case Repo.all(from(u in User, where: u.github_username == ^subdomain, select: u.id, limit: 1)) do
      [user_id] -> {:ok, user_id}
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
      |> IO.inspect(label: "PATH")

  defp get_post(user_id, "") do
  end

  defp get_post(user_id, path) do
    path = path <> ".md"

    case from(p in Post, where: p.path == ^path and p.user_id == ^user_id)
         |> Repo.all() do
      [] -> :post_not_found
      [post] -> {:ok, post}
    end
  end
end
