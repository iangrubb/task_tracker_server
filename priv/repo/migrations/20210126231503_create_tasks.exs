defmodule TaskTrackerServer.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :project_id, references(:projects, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:project_id])
  end
end
