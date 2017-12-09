defmodule TilWeb.PublishController do
  use TilWeb, :controller

  def perform(conn, %{"github_uid" => uid}) do
    # perform a pull of this repository
    json conn, "{}"
  end
end
