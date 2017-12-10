defmodule Repository do
  import Ecto.Query, warn: false
  alias Til.Repo
  alias Til.Repository.Post

  alias Til.Accounts.User

  def posts_for(%User{} = user) do
    from(p in Post, where: p.user_id == ^user.id)
    |> Repo.all()
  end

  def posts_for(_), do: []
end
