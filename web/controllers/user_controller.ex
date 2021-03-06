defmodule Alegro.UserController do
  use Alegro.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, [handler: Alegro.Auth] when action in [:index, :show]

  def index(conn, _params) do
    users = Repo.all(Alegro.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Alegro.User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = Alegro.User.changeset(%Alegro.User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = Alegro.User.registration_changeset(%Alegro.User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Alegro.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
