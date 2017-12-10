defmodule TilWeb.PublishController do
  use TilWeb, :controller
  alias Til.Github
  alias Til.Accounts

  def perform(conn, %{"github_uid" => uid}) do
    spawn(fn ->
      user = Accounts.get_user_by_github_id(uid)
      # perform a sync of this repository
      if user, do: Github.sync_repo(user)
    end)
    json conn, %{}
  end
end
