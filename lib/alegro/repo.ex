defmodule Alegro.Repo do
  @moduledoc """
  In memory repository.
  """
  def all(Alegro.User) do
    [
      %Alegro.User{id: "1", name: "Giovanni Sakti", username: "giosakti", password: "test1234"},
      %Alegro.User{id: "2", name: "Iqbal Farabi", username: "qbl", password: "test1234"},
      %Alegro.User{id: "3", name: "Raymond Ralibi", username: "ralibi", password: "test1234"},
      %Alegro.User{id: "4", name: "Tara Baskara", username: "tbaskara", password: "test1234"},
    ]
  end

  def all(_module), do: []

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end
end
