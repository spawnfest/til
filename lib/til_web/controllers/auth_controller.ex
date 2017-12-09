defmodule TilWeb.AuthController do
  use TilWeb, :controller
  alias Til.Accounts
  require Logger

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
    case Accounts.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> configure_session(renew: true)
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully signed in.")
        |> redirect(to: "/")

      oops ->
        Logger.error("Accounts.find_or_create ERROR #{inspect(oops)}")

        conn
        |> put_flash(:error, "Something went wrong please try again")
        |> redirect(to: "/")
    end
  end
end
