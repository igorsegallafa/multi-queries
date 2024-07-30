defmodule MultiQueries.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias MultiQueries.Repo

      import Ecto
      import Ecto.Query
      import MultiQueries.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MultiQueries.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MultiQueries.Repo, {:shared, self()})
    end

    :ok
  end
end
