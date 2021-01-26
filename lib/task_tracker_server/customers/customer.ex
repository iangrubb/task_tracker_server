defmodule TaskTrackerServer.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :name, :string
    has_many :projects, TaskTrackerServer.Projects.Project

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
