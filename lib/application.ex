defmodule MultiQueries.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link(children(Mix.env()), strategy: :one_for_one)
  end

  def children(:test), do: [MultiQueries.Repo]
  def children(_), do: []
end
