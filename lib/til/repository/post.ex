defmodule Til.Repository.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Til.Repository.Post


  @primary_key false
  schema "posts" do
    field :path, :string, primary_key: true
    field :user_id, :id, primary_key: true

    field :contents, :string
    field :sha, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:path, :sha, :contents])
    |> validate_required([:path, :sha, :contents])
  end
end
