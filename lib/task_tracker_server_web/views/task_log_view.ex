defmodule TaskTrackerServerWeb.TaskLogView do
  use TaskTrackerServerWeb, :view
  alias TaskTrackerServerWeb.TaskLogView
  alias TaskTrackerServerWeb.TaskView

  def render("index.json", %{task_logs: task_logs}) do
    %{data: render_many(task_logs, TaskLogView, "task_log.json")}
  end

  def render("show.json", %{task_log: task_log}) do
    %{data: render_one(task_log, TaskLogView, "task_log_with_belongs.json")}
  end

  def render("none.json", _) do
    %{data: nil}
  end

  def render("task_log_with_belongs.json", %{task_log: task_log}) do
    %{id: task_log.id, start_time: task_log.start_time, task: TaskView.render("show.json", %{task: task_log.task})}
  end

  def render("task_log.json", %{task_log: task_log}) do
    %{id: task_log.id, user_id: task_log.user_id, task_id: task_log.task_id}
  end
end
