defmodule TilWeb.Views.TilServerView do
  use TilWeb, :view
  alias Til.Accounts.User
  alias Til.Repository.Post

  defp markdown_to_html(body) do
    {:ok, html, []} =
      Earmark.as_html(body, %Earmark.Options{
        gfm: true,
        breaks: false
      })

    {:safe, html}
  end

  def user_label(nil), do: ""
  def user_label(%User{} = user), do: user.name || user.github_username

  def avatar(%User{avatar_url: avatar_url})
      when not is_nil(avatar_url) and avatar_url != "",
      do: avatar_url

  def avatar(_), do: "https://www.gravatar.com/avatar/?d=identicon"

  def post_url(%Post{} = post) do
    post.path |> String.replace_suffix(".md", "")
  end
end
