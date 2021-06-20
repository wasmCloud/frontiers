defmodule FrontiersSiteWeb.Router do
  use FrontiersSiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrontiersSiteWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrontiersSiteWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/frontier/:frontier", FrontierLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrontiersSiteWeb do
  #   pipe_through :api
  # end
end
