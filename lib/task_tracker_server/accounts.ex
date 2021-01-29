defmodule TaskTrackerServer.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TaskTrackerServer.Repo

  alias TaskTrackerServer.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def get_user_with_credentials(%{"name" => name, "password" => password}) do
    Repo.get_by(User, name: name)
    |> Bcrypt.check_pass(password)
  end

  def get_user_with_credentials(_missing_credentials) do
    {:error, :unauthorized}
  end

  def create_auth_token_for_user(user) do
    create_token("auth", user)
  end

  def create_login_token_for_user(user) do
    create_token("login", user)
  end

  def get_user_from_auth_token(token) do
    get_user_from_token(token, "auth")
  end

  def get_user_from_login_token(token) do
    get_user_from_token(token, "login")
  end

  def revoke_user_session(%User{id: user_id}) do
    from(u in User, where: u.id == ^user_id)
    |> Repo.update_all(inc: [raw_session_token: 1])
  end

  defp create_token(type, %User{id: id, raw_session_token: raw_session_token}) do
    Phoenix.Token.sign(TaskTrackerServerWeb.Endpoint, type, %{
      id: id,
      raw_session_token: raw_session_token
    })
  end

  defp validate_token(token, type) do
    Phoenix.Token.verify(TaskTrackerServerWeb.Endpoint, type, token)
  end

  defp get_user_with_session(user_id, raw_session_token) do
    Repo.get_by(User, id: user_id, raw_session_token: raw_session_token)
  end

  defp get_user_from_token(token, type) do
    case validate_token(token, type) do
      {:ok, %{id: id, raw_session_token: raw_session_token}} ->
        case get_user_with_session(id, raw_session_token) do
          nil ->
            {:error, :outdated_session}

          user ->
            {:ok, user}
        end

      {:error, token_error} ->
        {:error, token_error}
    end
  end
end
