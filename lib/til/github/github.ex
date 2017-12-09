defmodule Til.Github do
  alias Til.Accounts.User

  def create_repo(%User{github_access_token: access_token} = _user) do
    payload =
      %{
        name: "tilhub",
        description: "Things I have learnt!"
      }
      |> Poison.encode!()

    request(:post, "/user/repos", payload, access_token)
  end

  @api_url "https://api.github.com"
  @headers [{"accept", "application/vnd.github.v3+json"}]
  def request(method, "/" <> _ = path, body, access_token) do
    HTTPoison.request(method, @api_url <> path, body, [
      {"authorization", "token #{access_token}"} | @headers
    ])
  end
end
