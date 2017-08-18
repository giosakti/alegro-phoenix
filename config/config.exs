# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :alegro,
  ecto_repos: [Alegro.Repo]

# Configures the endpoint
config :alegro, Alegro.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nTkEloasRZAorD4xbCFUbQ6aL9K/Qkv/iVh9Vd/HQlnd/KvJmjlOL56D/J8qy5et",
  render_errors: [view: Alegro.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Alegro.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Alegro",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "ri+Dl3BBaBYrNhWEZJJUbaVLFhslH5GAfLYUP5aDJ0zhfvxzHFcYh1FysCiLxkUL",
  serializer: Alegro.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
