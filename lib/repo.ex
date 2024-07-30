defmodule MultiQueries.Repo do
  use Ecto.Repo,
    otp_app: :multi_queries,
    adapter: Ecto.Adapters.MyXQL
end
