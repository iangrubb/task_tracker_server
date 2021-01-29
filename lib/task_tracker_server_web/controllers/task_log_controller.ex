defmodule TaskTrackerServerWeb.TaskLogController do
  use TaskTrackerServerWeb, :controller

  alias TaskTrackerServer.Work
  alias TaskTrackerServer.Work.TaskLog

  action_fallback TaskTrackerServerWeb.FallbackController

  def index(conn, _params) do
    task_logs = Work.list_task_logs()
    render(conn, "index.json", task_logs: task_logs)
  end

  def create(conn, %{"task_log" => task_log_params}) do

    with {:ok, %TaskLog{} = task_log} <- Work.create_task_log(task_log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_log_path(conn, :show, task_log))
      |> render("show.json", task_log: task_log)
    end
  end

  def show(conn, %{"id" => id}) do
    task_log = Work.get_task_log!(id)
    render(conn, "show.json", task_log: task_log)
  end

  def active_task(%{assigns: %{current_user: current_user}} = conn, _params) do
    case Work.get_current_task_log(current_user.id) do
      nil ->
        render(conn, "none.json", %{})
      task_log ->
        task_log = Work.task_log_with_belongs(task_log.id)
        render(conn, "show.json", task_log: task_log)
    end
  end

  def start_log(conn, %{"task_log" => task_log_params}) do
    {:ok, task_log} = Work.start_task_log(task_log_params)
    task_log = Work.task_log_with_belongs(task_log.id)
    render(conn, "show.json", task_log: task_log)
  end

  def finish_log(conn, %{"id" => id}) do

    task_log = Work.get_task_log!(id)

    with {:ok, %TaskLog{} = task_log} <- Work.finish_task_log(task_log) do
      task_log = Work.task_log_with_belongs(task_log.id)
      render(conn, "show.json", task_log: task_log)
    end
  end

end
