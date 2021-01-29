defmodule TaskTrackerServer.Work.TaskLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_logs" do
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    belongs_to :user, TaskTrackerServer.Accounts.User
    belongs_to :task, TaskTrackerServer.Projects.Task

    timestamps()
  end

  @doc false
  def changeset(task_log, attrs) do
    task_log
    |> cast(attrs, [:start_time, :end_time, :user_id, :task_id])
    |> validate_required([:user_id, :task_id])
  end
end
