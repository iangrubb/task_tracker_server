defmodule TaskTrackerServer.Projects.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string
    belongs_to :project, TaskTrackerServer.Projects.Project

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :project_id])
    |> validate_required([:description, :project_id])
  end
end
