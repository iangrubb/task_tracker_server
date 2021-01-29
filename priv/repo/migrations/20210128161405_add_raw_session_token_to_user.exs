defmodule TaskTrackerServer.Repo.Migrations.AddRawSessionTokenToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :raw_session_token, :integer, default: 1
    end
  end
end
