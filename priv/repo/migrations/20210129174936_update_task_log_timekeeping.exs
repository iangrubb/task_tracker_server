defmodule TaskTrackerServer.Repo.Migrations.UpdateTaskLogTimekeeping do
  use Ecto.Migration

  def change do
    alter table(:task_logs) do
      remove :duration_minutes, :integer
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
    end
  end
end
