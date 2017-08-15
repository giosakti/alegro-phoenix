defmodule Alegro.PageControllerTest do
  use Alegro.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Alegro"
  end
end
