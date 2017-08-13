# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Alegro.Repo.insert!(%Alegro.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.

alias Alegro.Repo
alias Alegro.Category

for category <- ~w(Action Drama Romance Comedy Sci-fi) do
  Repo.insert!(%Category{name: category})
end