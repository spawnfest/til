defmodule TilWeb.Views.ViewUtils do
  def current_user(%Plug.Conn{assigns: %{current_user: current_user}}), do: current_user
end
