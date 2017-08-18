defmodule Alegro.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  alias Alegro.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user = Guardian.Plug.current_resource(conn)

    cond do
      user ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Alegro.User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  def unauthenticated(conn, params) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: Helpers.page_path(conn, :index))
    |> halt()
  end
end
