defmodule RedealWeb.Router do
  use RedealWeb, :router

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

  scope "/", RedealWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/deal", as: :deal do
    pipe_through :api
    # get "/random", RedealWeb.DealController, :get_random
    # get "/1nt", RedealWeb.DealController, :get_one_nt
    # get "/1spade", RedealWeb.DealController, :get_one_s
    # get "/1heart", RedealWeb.DealController, :get_one_h
    # get "/1diamond", RedealWeb.DealController, :get_one_d
    get "/:opening", RedealWeb.DealController, :get_deal

  end

  # Other scopes may use custom stacks.
  # scope "/api", RedealWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RedealWeb.Telemetry
    end
  end
end
