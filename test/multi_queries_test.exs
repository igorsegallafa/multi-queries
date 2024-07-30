defmodule MultiQueriesTest do
  use MultiQueries.RepoCase

  test "should interpolate the query parameters properly" do
    instance =
      MultiQueries.new(MultiQueries.Repo)
      |> MultiQueries.append("SELECT 1")
      |> MultiQueries.append("SELECT ?", [1000])
      |> MultiQueries.append("SELECT ? AS col1, ? AS col2, ? AS col3", [1, "str", false])

    assert instance.queries == ["SELECT 1", "SELECT 1000", "SELECT 1 AS col1, 'str' AS col2, FALSE AS col3"]
    assert {:ok, _} = MultiQueries.execute(instance)
  end

  test "should interpolate the query parameters properly for ecto query builder" do
    query =
      from t in "test_table",
        where: t.id > 0,
        select: t.name

    instance =
      MultiQueries.new(MultiQueries.Repo) |> MultiQueries.append(query)

    assert instance.queries == ["SELECT t0.`name` FROM `test_table` AS t0 WHERE (t0.`id` > 0)"]
    assert {:ok, _} = MultiQueries.execute(instance)
  end

  test "should interpolate the query parameters properly for query block" do
    query = """
    SELECT
      ? AS column1,
      ? AS column2,
      TRUE AS column3
    """

    instance =
      MultiQueries.new(MultiQueries.Repo) |> MultiQueries.append(query, [1, 2])

    assert instance.queries == ["SELECT\n  1 AS column1,\n  2 AS column2,\n  TRUE AS column3\n"]
    assert {:ok, _} = MultiQueries.execute(instance)
  end
end
