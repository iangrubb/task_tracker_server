defmodule TaskTrackerServer.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    belongs_to :customer, TaskTrackerServer.Customers.Customer
    has_many :tasks, TaskTrackerServer.Projects.Task

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :customer_id])
    |> validate_required([:name])
  end
end
