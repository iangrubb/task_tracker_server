defmodule TaskTrackerServer.Work.TaskLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_logs" do
    field :duration_minutes, :integer
    belongs_to :user, TaskTrackerServer.Accounts.User
    belongs_to :task, TaskTrackerServer.Projects.Task

    timestamps()
  end

  @doc false
  def changeset(task_log, attrs) do
    task_log
    |> cast(attrs, [:duration_minutes, :user_id, :task_id])
    |> validate_required([:duration_minutes, :task_id])
  end
end
