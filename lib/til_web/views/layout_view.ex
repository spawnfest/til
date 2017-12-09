defmodule TilWeb.LayoutView do
  use TilWeb, :view

  alias Til.Accounts.User

  def user_signed_in?(%Plug.Conn{assigns: %{current_user: %User{}}}), do: true
  def user_signed_in?(_), do: false

  def user_label(%Plug.Conn{assigns: %{current_user: nil}}), do: "Anonymous Coward"

  def user_label(%Plug.Conn{assigns: %{current_user: %User{name: name}}})
      when not is_nil(name) and name != "",
      do: name

  def user_label(%Plug.Conn{assigns: %{current_user: %User{github_username: username}}}), do: username
end
