defmodule Til.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Til.Accounts.User

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:avatar_url, :string)

    field(:github_uid, :integer)
    field(:github_username, :string)
    field(:github_access_token, :string)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :username, :access_token, :avatar_url])
    |> validate_required([:name, :email, :username, :access_token, :avatar_url])
  end
end
