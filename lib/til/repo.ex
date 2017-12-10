defmodule Til.Repo do
  use Ecto.Repo, otp_app: :til
  alias __MODULE__
  import Ecto.Query

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def any?(queryable, opts \\ []) do
    queryable = from(q in queryable, where: ^opts)
    all(from(q in queryable, select: 1, limit: 1)) == [1]
  end
end
