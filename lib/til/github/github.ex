defmodule Til.Github do
  alias Til.Accounts.User

  def create_repo(%User{} = user) do
    request(
      :post,
      "/user/repos",
      %{
        name: "tilhub",
        description: ":rainbow: Awesome things I have learnt!"
      }
      |> Poison.encode!(),
      user.github_access_token
    )
  end

  def create_file(%User{} = user, filename, contents) do
    request(
      :put,
      "/repos/#{user.github_username}/#{user.github_repo}/contents/#{filename}",
      %{path: filename, message: "Created #{filename}", content: contents |> Base.encode64()}
      |> Poison.encode!(),
      user.github_access_token
    )
  end

  @api_url "https://api.github.com"
  @headers [{"accept", "application/vnd.github.v3+json"}]
  def request(method, "/" <> _ = path, body, access_token) do
    HTTPoison.request(method, @api_url <> path, body, [
      {"authorization", "token #{access_token}"} | @headers
    ])
  end
end
