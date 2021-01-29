defmodule TaskTrackerServerWeb.UserView do
  use TaskTrackerServerWeb, :view
  alias TaskTrackerServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show_current.json", %{user: user, auth_token: auth_token}) do
    %{data: %{
      user: render_one(user, UserView, "user.json"),
      auth_token: auth_token
    }}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name}
  end

end
