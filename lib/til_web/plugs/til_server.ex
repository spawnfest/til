defmodule TilWeb.Plugs.TilServerPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Til.Repo
  import Ecto.Query
  alias Til.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    # get subdomain
    with {:ok, subdomain} <- get_subdomain(conn),
         # get path
         {:ok, path} <- get_path(conn),
         # find the til
         {:ok, til} <- get_til(subdomain, path) do
      # render it
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(:ok, "<!doctype html><h1>Awesome</h1>")
    end
  end

  # TODO: move to config
  @host_suffix ".tilhub.in"
  defp get_subdomain(conn) do
    subdomain = conn.host |> to_string |> String.replace_suffix(@host_suffix, "")

    case Repo.all(from(u in User, where: u.username == ^subdomain, select: 1, limit: 1)) do
      [_] -> {:ok, subdomain}
      _ -> :site_not_found
    end
  end

  defp get_path(conn), do: {:ok, conn.path |> Path.join()}

  defp get_til(subdomain, path) do
    nil
    # Repo.all(from p in Post, where: p.path == path and p.subdomain == subdomain)
  end
end
