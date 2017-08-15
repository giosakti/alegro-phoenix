defmodule Alegro.TestHelpers do
  alias Alegro.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "supersecret",
    }, attrs)
    %Alegro.User{}
    |> Alegro.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(attrs \\ %{}) do
    changes = Dict.merge(%{}, attrs)
    %Alegro.Video{}
    |> Alegro.Video.changeset(changes)
    |> Repo.insert!()
  end

  def insert_video_as_user(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end
end
