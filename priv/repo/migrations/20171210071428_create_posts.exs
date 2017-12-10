defmodule Til.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add(:path, :string, null: false, primary_key: true)
      add(:user_id, references(:users, on_delete: :nothing), primary_key: true)

      add(:sha, :string, null: false)
      add(:contents, :text, null: false)

      timestamps()
    end

    create(index(:posts, [:user_id]))
    create(index(:posts, [:user_id, :path], unique: true))
  end
end
