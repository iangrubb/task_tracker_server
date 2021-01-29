defmodule TaskTrackerServerWeb.ProjectView do
  use TaskTrackerServerWeb, :view
  alias TaskTrackerServerWeb.ProjectView
  alias TaskTrackerServerWeb.CustomerView
  alias TaskTrackerServerWeb.TaskView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project_with_tasks.json")}
  end

  def render("project_with_tasks.json", %{project: project}) do
    render("project.json", %{project: project})
    |> Map.put(:tasks, TaskView.render("index.json", %{tasks: project.tasks}))
  end

  def render("project.json", %{project: project}) do
    %{id: project.id, name: project.name, customer_id: project.customer_id, customer: CustomerView.render("show.json", %{customer: project.customer}) }
  end

end
