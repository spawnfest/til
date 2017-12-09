defmodule TilWeb.Router do
  use TilWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug TilWeb.Plugs.LoadUser
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TilWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/github-access-notice", PageController, :github_access_notice)
  end

  scope "/auth", TilWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TilWeb do
  #   pipe_through :api
  # end
end
