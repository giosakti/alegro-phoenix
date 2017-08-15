defmodule Alegro.Router do
  use Alegro.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Alegro.Auth, repo: Alegro.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Alegro do
    pipe_through :browser # Use the default browser stack

    get "/hello/:name", HelloController, :world
    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/videos", VideoController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", as: :manage do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  scope "/api", Alegro.Api, as: :api do
    pipe_through :api

    resources "/videos", VideoController
  end
end
