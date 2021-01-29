defmodule TaskTrackerServerWeb.TaskLogControllerTest do
  use TaskTrackerServerWeb.ConnCase

  alias TaskTrackerServer.Work
  alias TaskTrackerServer.Work.TaskLog

  @create_attrs %{
    duration_minutes: 42
  }
  @update_attrs %{
    duration_minutes: 43
  }
  @invalid_attrs %{duration_minutes: nil}

  def fixture(:task_log) do
    {:ok, task_log} = Work.create_task_log(@create_attrs)
    task_log
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all task_logs", %{conn: conn} do
      conn = get(conn, Routes.task_log_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task_log" do
    test "renders task_log when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_log_path(conn, :create), task_log: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.task_log_path(conn, :show, id))

      assert %{
               "id" => id,
               "duration_minutes" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_log_path(conn, :create), task_log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task_log" do
    setup [:create_task_log]

    test "renders task_log when data is valid", %{
      conn: conn,
      task_log: %TaskLog{id: id} = task_log
    } do
      conn = put(conn, Routes.task_log_path(conn, :update, task_log), task_log: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.task_log_path(conn, :show, id))

      assert %{
               "id" => id,
               "duration_minutes" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task_log: task_log} do
      conn = put(conn, Routes.task_log_path(conn, :update, task_log), task_log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task_log" do
    setup [:create_task_log]

    test "deletes chosen task_log", %{conn: conn, task_log: task_log} do
      conn = delete(conn, Routes.task_log_path(conn, :delete, task_log))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.task_log_path(conn, :show, task_log))
      end
    end
  end

  defp create_task_log(_) do
    task_log = fixture(:task_log)
    %{task_log: task_log}
  end
end
