defmodule Alegro.HelloController do
  use Alegro.Web, :controller

  def world(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
end