defmodule Alegro.HelloController do
  use Alegro.Web, :controller

  def world(conn, _params) do
    render conn, "world.html"
  end
end