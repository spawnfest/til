# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :til, ecto_repos: [Til.Repo]

config :til, [host: "tilhub.in"]

# Configures the endpoint
config :til, TilWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "StSyRDtl0M+OrZ2ix9k/CZJvGUOUu/Yye2+VgfoEJ4JNFT1FPdWt7QH5fdocAuhb",
  render_errors: [view: TilWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Til.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    github:
      {Ueberauth.Strategy.Github, [default_scope: "public_repo", send_redirect_uri: false]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("TH_GITHUB_CLIENT_ID"),
  client_secret: System.get_env("TH_GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
