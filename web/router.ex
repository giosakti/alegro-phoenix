defmodule Alegro.Router do
  use Alegro.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Alegro.Auth, repo: Alegro.Repo
  end

  pipeline :browser_ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Alegro.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Alegro do
    pipe_through [:browser, :browser_auth]

    get "/hello/:name", HelloController, :world
    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/videos", VideoController
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    scope "/manage", as: :manage do
      pipe_through [:browser_ensure_auth]

      resources "/videos", VideoController
    end
  end

  scope "/api", Alegro.Api, as: :api do
    pipe_through :api

    resources "/videos", VideoController
  end
end
