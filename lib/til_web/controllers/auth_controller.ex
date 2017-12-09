defmodule TilWeb.AuthController do
  use TilWeb, :controller
  alias Til.Accounts

  plug(Ueberauth)

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to sign in.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    {:ok, user} =
      auth
      |> Accounts.find_or_create()

    conn
    |> redirect(to: "/")
  end
end
