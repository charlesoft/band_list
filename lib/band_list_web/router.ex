defmodule BandListWeb.Router do
  use BandListWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BandListWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BandListWeb do
    pipe_through :browser

    live "/bands", BandLive.Index, :index
    live "/bands/new", BandLive.Index, :new
    live "/bands/:id/edit", BandLive.Index, :edit

    live "/bands/:id", BandLive.Show, :show
    live "/bands/:id/show/edit", BandLive.Show, :edit

    live "/bands/:band_id/members", MemberLive.Index, :index
    live "/bands/:band_id/members/new", MemberLive.Index, :new
    live "/bands/:band_id/members/:id/edit", MemberLive.Index, :edit

    live "/bands/:band_id/members/:id", MemberLive.Show, :show

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BandListWeb do
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

      live_dashboard "/dashboard", metrics: BandListWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
