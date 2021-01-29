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

  # def update(conn, %{"id" => id, "task_log" => task_log_params}) do
  #   task_log = Work.get_task_log!(id)

  #   with {:ok, %TaskLog{} = task_log} <- Work.update_task_log(task_log, task_log_params) do
  #     render(conn, "show.json", task_log: task_log)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   task_log = Work.get_task_log!(id)

  #   with {:ok, %TaskLog{}} <- Work.delete_task_log(task_log) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
