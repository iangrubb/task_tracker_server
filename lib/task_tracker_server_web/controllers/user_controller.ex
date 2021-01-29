defmodule TaskTrackerServerWeb.UserController do
  use TaskTrackerServerWeb, :controller

  alias TaskTrackerServer.Accounts
  alias TaskTrackerServer.Accounts.User

  alias TaskTrackerServerWeb.SessionController
  alias TaskTrackerServerWeb.SessionView

  action_fallback TaskTrackerServerWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> SessionController.put_login_cookie_for_user(user)
      |> put_view(SessionView)
      |> render("login.json", %{user: user})
    end
  end
end
