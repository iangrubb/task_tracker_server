defmodule TaskTrackerServerWeb.TaskView do
  use TaskTrackerServerWeb, :view
  alias TaskTrackerServerWeb.TaskView
  alias TaskTrackerServerWeb.TaskLogView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id, description: task.description}
  end

end
