defmodule TaskTrackerServerWeb.TaskController do
  use TaskTrackerServerWeb, :controller

  alias TaskTrackerServer.Projects
  alias TaskTrackerServer.Projects.Task

  action_fallback TaskTrackerServerWeb.FallbackController

  def index(conn, _params) do
    tasks = Projects.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Projects.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Projects.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Projects.get_task!(id)

    with {:ok, %Task{} = task} <- Projects.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Projects.get_task!(id)

    with {:ok, %Task{}} <- Projects.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
