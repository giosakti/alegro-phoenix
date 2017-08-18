defmodule Alegro.AuthTest do
  use Alegro.ConnCase
  alias Alegro.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Alegro.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "call places user from guardian current_resource into assigns", %{conn: conn} do
    user = insert(:user)
    conn =
      conn
      |> Guardian.Plug.sign_in(user)
      |> Auth.call(Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "call with nil guardian current_resource sets current_user assign to nil", %{conn: conn} do
    conn = Auth.call(conn, Repo)
    assert conn.assigns.current_user == nil
  end

  test "unauthenticated halts",
    %{conn: conn} do

    conn = Auth.unauthenticated(conn, [])
    assert conn.halted
  end

  test "login sign in the user using Guardian", %{conn: conn} do
    user = insert(:user)
    login_conn =
      conn
      |> Auth.login(user)
      |> send_resp(:ok, "")
    next_conn = get(login_conn, "/")
    assert Guardian.Plug.current_resource(next_conn).id == user.id
  end

  test "logout drops the session from Guardian", %{conn: conn} do
    user = insert(:user)
    logout_conn =
      conn
      |> Auth.login(user)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute Guardian.Plug.current_resource(next_conn)
  end

  test "login with a valid username and pass", %{conn: conn} do
    user = build(:user, username: "me") |> set_password("secret") |> insert
    {:ok, conn} =
      Auth.login_by_username_and_pass(conn, "me", "secret", repo: Repo)

    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "login with a not found user", %{conn: conn} do
    assert {:error, :not_found, _conn} =
      Auth.login_by_username_and_pass(conn, "me", "secret", repo: Repo)
  end

  test "login with password mismatch", %{conn: conn} do
    _ = build(:user, username: "me") |> set_password("secret") |> insert
    assert {:error, :unauthorized, _conn} =
      Auth.login_by_username_and_pass(conn, "me", "wrong", repo: Repo)
  end
end
