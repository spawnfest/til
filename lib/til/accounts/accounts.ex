defmodule Til.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Til.Repo
  alias Til.Github

  alias Til.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def find_or_create(
        _auth = %Ueberauth.Auth{
          uid: uid,
          info: %{name: name, nickname: nickname, email: email, image: image},
          credentials: %{token: token}
        }
      ) do
    case Repo.all(from(u in User, where: u.github_uid == ^uid)) do
      [user] ->
        {:ok, user}

      [] ->
        user = %User{
          name: name,
          email: email,
          avatar_url: image,
          github_uid: uid,
          github_username: nickname,
          github_access_token: token,
          github_repo: "tilhub"
        }

        user = Repo.insert!(user)

        # TODO: run this in a different process
        Github.setup_til_repo(user)

        {:ok, user}
    end
  end

  def get_user_by_github_id(github_uid) do
    Repo.get_by(User, github_uid: github_uid)
  end
end
