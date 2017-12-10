defmodule Til.Github do
  alias Til.Accounts.User
  alias Til.Repository.Post
  alias Til.Repo
  import Ecto.Query

  @hello_world_template Path.expand("../../templates/hello_world.md", __DIR__)
                        |> File.read!()
  def setup_til_repo(%User{} = user) do
    {:ok, _} = create_repo(user)
    {:ok, _} = create_file(user, "hello-world.md", @hello_world_template)
    {:ok, _} = create_push_webhook(user)
  end

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

  def sync_repo(%User{} = user) do
    with {:ok, resp} <- contents(user, ""),
         {:ok, files} <- parse_json(resp) do
      Enum.each(files, fn file ->
        download_file(user, file)
      end)
    end
  end

  require Logger

  def download_file(user, %{"type" => "file", "path" => path, "sha" => sha} = _file) do
    if Repo.any?(
         from(
           p in Post,
           where: p.user_id == ^user.id and p.path == ^path and p.sha == ^sha
         )
       ) do
      # already downloaded, nothing to do
      :ok
    else
      post =
        request(
          :get,
          "/repos/#{user.github_username}/#{user.github_repo}/contents/#{path}",
          [],
          user.github_access_token
        )
        |> parse_contents(user)

      # download and delete the old and insert the new
      Repo.delete_all(from(p in Post, where: p.user_id == ^user.id and p.path == ^path))

      Repo.insert(post)
    end
  end

  def download_file(_user, file) do
    Logger.info("skipping #{file["type"]}, #{file["path"]}")
  end

  defp parse_contents({:ok, %HTTPoison.Response{status_code: 200, body: body}}, user) do
    file =
      body
      |> Poison.decode!()

    contents = file["content"] |> Base.decode64!(padding: false, ignore: :whitespace)

    {title, tags, body} = parse_front_matter(contents)

    %Post{
      user_id: user.id,
      path: file["path"],
      sha: file["sha"],
      title: title,
      tags: tags,
      body: body,
      raw_contents: contents
    }
  end

  def parse_front_matter(contents) do
    [front_matter, body] =
      contents
      |> String.replace_prefix("---", "")
      |> String.trim()
      |> String.split("---", tokens: 2)

    front_matter = YamlElixir.read_from_string(front_matter)

    {front_matter["title"], front_matter["tags"] || [], body}
  end

  defp parse_json(%HTTPoison.Response{status_code: 200, body: body}) do
    {:ok, Poison.decode!(body)}
  end

  def contents(%User{} = user, path) do
    request(
      :get,
      "/repos/#{user.github_username}/#{user.github_repo}/contents/#{path}",
      [],
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

  @tilhub_url "https://#{Application.get_env(:til, :host)}"
  def create_push_webhook(%User{} = user) do
    request(
      :post,
      "/repos/#{user.github_username}/#{user.github_repo}/hooks",
      %{
        name: "web",
        active: true,
        events: ["push"],
        config: %{
          url: "#{@tilhub_url}/publish/#{user.github_uid}",
          content_type: "json"
        }
      }
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
