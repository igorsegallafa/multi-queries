defmodule MultiQueries do
  defstruct repo: nil, queries: [], params: []

  def new(repo) do
    %__MODULE__{
      repo: repo
    }
  end

  def append(instance, query, params \\ [])

  def append(instance = %__MODULE__{}, query = %Ecto.Query{}, _params) do
    {query, params} = instance.repo.to_sql(:all, query)
    append(instance, query, params)
  end

  def append(instance = %__MODULE__{}, query, params) when is_binary(query) do
    %__MODULE__{
      instance |
      queries: instance.queries ++ [interpolate_query(instance, query, params)],
      params: instance.params ++ [params]
    }
  end

  def execute(instance = %__MODULE__{}) do
    query = instance.queries |> Enum.join("; ")

    instance.repo.transaction(fn ->
      instance.repo.query_many!(query)
    end)
  end

  defp interpolate_query(instance, query, params) when is_binary(query) and is_list(params) do
    regex = ~r/SELECT\s+--begin_block--([\s\S]*?) FROM\s+`--end_block--`/
    macro_fragment =
      quote do
        import Ecto.Query
        from "--end_block--", select: fragment(unquote("--begin_block--" <> query), unquote_splicing(params))
      end

    {result, _} = Code.eval_quoted(macro_fragment)
    {sql, _params} = instance.repo.to_sql(:all, result)

    Regex.scan(regex, sql, capture: :all_but_first)
    |> List.flatten()
    |> List.first()
  end
end
