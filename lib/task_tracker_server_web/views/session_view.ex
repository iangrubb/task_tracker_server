defmodule TaskTrackerServerWeb.SessionView do
  use TaskTrackerServerWeb, :view
  alias TaskTrackerServerWeb.UserView

  alias TaskTrackerServer.Accounts

  def render("login.json", %{user: user}) do
    %{data: %{
      login_successful: true,
      user: render_one(user, UserView, "user.json"),
      auth_token: Accounts.create_auth_token_for_user(user)
    }}
  end

  def render("login.json", _) do
    %{data: %{login_successful: false}}
  end

  def render("logout.json", %{success: success}) do
    %{data: %{logout_successful: success}}
  end
end
