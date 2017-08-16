defmodule Alegro.Factory do
  use ExMachina.Ecto, repo: Alegro.Repo

  def user_factory do
    %Alegro.User{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "supersecret",
    }
  end

  def set_password(user, password) do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)
    %{user | password_hash: hashed_password}
  end

  def video_factory do
    %Alegro.Video{
      title: "New Video",
      url: "http://youtu.be",
      description: "New video description",
    }
  end
end
