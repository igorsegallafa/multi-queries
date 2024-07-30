defmodule MultiQueries.Repo.Migrations.AddTestTable do
  use Ecto.Migration

  def up do
    create table("test_table") do
      add :name, :string, size: 40
    end
  end

  def down do
    drop table("test_table")
  end
end
