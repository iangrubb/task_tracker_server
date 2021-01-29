defmodule TaskTrackerServerWeb.TaskLogView do
  use TaskTrackerServerWeb, :view
  alias TaskTrackerServerWeb.TaskLogView

  def render("index.json", %{task_logs: task_logs}) do
    %{data: render_many(task_logs, TaskLogView, "task_log.json")}
  end

  def render("show.json", %{task_log: task_log}) do
    %{data: render_one(task_log, TaskLogView, "task_log.json")}
  end

  def render("task_log.json", %{task_log: task_log}) do
    %{id: task_log.id, duration_minutes: task_log.duration_minutes, user_id: task_log.user_id, task_id: task_log.task_id}
  end
end
