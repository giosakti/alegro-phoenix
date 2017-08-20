defmodule Alegro.Api.SessionController do
  use Alegro.Web, :controller
  alias Alegro.Api.Auth

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        render(conn, "login.json", user: user)
      {:error, _reason, conn} ->
        render(conn, "error.json", message: "Invalid username/password combination")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> render("logout.json")
  end
end
