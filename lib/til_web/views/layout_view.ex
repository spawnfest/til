defmodule TilWeb.LayoutView do
  use TilWeb, :view

  alias Til.Accounts.User

  def user_signed_in?(%Plug.Conn{assigns: %{current_user: %User{}}}), do: true
  def user_signed_in?(_), do: false

  def user_label(%Plug.Conn{assigns: %{current_user: nil}}), do: "Anonymous Coward"

  def user_label(%Plug.Conn{assigns: %{current_user: %User{name: name}}})
      when not is_nil(name) and name != "",
      do: name

  def user_label(%Plug.Conn{assigns: %{current_user: %User{github_username: username}}}),
    do: username

  def avatar(%Plug.Conn{assigns: %{current_user: %User{avatar_url: avatar_url}}})
      when not is_nil(avatar_url) and avatar_url != "",
      do: avatar_url

  def avatar(_), do: "https://www.gravatar.com/avatar/?d=identicon"
end
