defmodule Til.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :avatar_url, :string

      add :github_uid, :integer
      add :github_username, :string
      add :github_access_token, :string

      timestamps()
    end

    create index(:users, [:github_uid], unique: true)

  end
end
