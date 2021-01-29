defmodule TaskTrackerServerWeb.Router do
  use TaskTrackerServerWeb, :router

  alias TaskTrackerServer.Accounts

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auto_login do
    plug :check_login_token
  end

  pipeline :authenticate do
    plug :check_auth_token
  end

  scope "/api", TaskTrackerServerWeb do
    pipe_through :api

    resources "/session", SessionController, only: [:create], singleton: true
    resources "/users", UserController, only: [:create]
  end

  scope "/api", TaskTrackerServerWeb do
    pipe_through [:api, :auto_login]

    resources "/session", SessionController, only: [:show], singleton: true
  end

  scope "/api", TaskTrackerServerWeb do
    pipe_through [:api, :authenticate]

    resources "/customers", CustomerController, only: [:index, :show, :create, :update, :delete]
    resources "/projects", ProjectController, only: [:index, :show, :create, :update, :delete]
    resources "/tasks", TaskController, only: [:index, :show, :create, :update, :delete]
    resources "/task_logs", TaskLogController, only: [:index, :show, :create]

    resources "/session", SessionController, only: [:delete], singleton: true
  end

  def check_login_token(conn, _opts) do
    case get_session(conn, :login_token) do
      nil -> conn
      token ->
        case Accounts.get_user_from_login_token(token) do
          {:ok, user} ->
            assign(conn, :current_user, user)
          _ -> conn
        end
    end
  end

  def check_auth_token(conn, _opts) do

    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    {:ok, user} <- Accounts.get_user_from_auth_token(token) do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
    end

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
