defmodule TaskTrackerServerWeb.Router do
  use TaskTrackerServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TaskTrackerServerWeb do
    pipe_through :api

    resources "/customers", CustomerController, only: [:index, :show, :create, :update, :delete]
    resources "/projects", ProjectController, only: [:index, :show, :create, :update, :delete]
    resources "/tasks", TaskController, only: [:index, :show, :create, :update, :delete]
    resources "/task_logs", TaskLogController, only: [:index, :show, :create]
    resources "/users", UserController, only: [:index, :show]
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TaskTrackerServerWeb.Telemetry
    end
  end
end
