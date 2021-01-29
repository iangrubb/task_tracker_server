defmodule TaskTrackerServerWeb.SessionController do
  use TaskTrackerServerWeb, :controller

  alias TaskTrackerServer.Accounts

  action_fallback TaskTrackerServerWeb.FallbackController

  def create(conn, %{"credentials" => credentials}) do
    case Accounts.get_user_with_credentials(credentials) do
      {:ok, user} ->
        conn
        |> put_login_cookie_for_user(user)
        |> render("login.json", %{user: user})
      _ ->
        render(conn, "login.json", %{})
    end
  end

  def show(%{assigns: %{current_user: current_user}} = conn, _id) do
    render(conn, "login.json", %{user: current_user})
  end

  def show(conn, _id) do
    render(conn, "login.json", %{})
  end

  def delete(%{assigns: %{current_user: current_user}} = conn, _id) do
    Accounts.revoke_user_session(current_user)
    render(conn, "logout.json", %{success: true})
  end

  def delete(conn, _id) do
    render(conn, "logout.json", %{success: false})
  end

  def put_login_cookie_for_user(conn, user) do
    put_session(conn, :login_token, Accounts.create_login_token_for_user(user))
  end
end
