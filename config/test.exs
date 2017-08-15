use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :alegro, Alegro.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :alegro, Alegro.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "alegro",
  password: "alegro",
  database: "alegro_test",
  hostname: "192.168.148.1",
  pool: Ecto.Adapters.SQL.Sandbox
