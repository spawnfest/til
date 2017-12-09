defmodule Til.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :avatar_url, :string

      add :github_uid, :string
      add :github_username, :string
      add :github_access_token, :string

      timestamps()
    end

  end
end
