defmodule TaskTrackerServer.Repo.Migrations.CreateTaskLogs do
  use Ecto.Migration

  def change do
    create table(:task_logs) do
      add :duration_minutes, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :task_id, references(:tasks, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:task_logs, [:user_id])
    create index(:task_logs, [:task_id])
  end
end
