defmodule Alegro.Router do
  use Alegro.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Alegro do
    pipe_through :browser # Use the default browser stack

    get "/hello/:name", HelloController, :world
    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Alegro do
  #   pipe_through :api
  # end
end
