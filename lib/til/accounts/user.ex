defmodule Til.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Til.Accounts.User


  schema "users" do
    field :access_token, :string
    field :avatar_url, :string
    field :email, :string
    field :name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :username, :access_token, :avatar_url])
    |> validate_required([:name, :email, :username, :access_token, :avatar_url])
  end
end
