import Config

config :multi_queries, MultiQueries.Repo,
  username: "root",
  password: "password",
  database: "test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :multi_queries, ecto_repos: [MultiQueries.Repo]
