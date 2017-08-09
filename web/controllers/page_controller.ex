defmodule Alegro.PageController do
  use Alegro.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
