defmodule TaskTrackerServer.WorkTest do
  use TaskTrackerServer.DataCase

  alias TaskTrackerServer.Work

  describe "task_logs" do
    alias TaskTrackerServer.Work.TaskLog

    @valid_attrs %{duration_minutes: 42}
    @update_attrs %{duration_minutes: 43}
    @invalid_attrs %{duration_minutes: nil}

    def task_log_fixture(attrs \\ %{}) do
      {:ok, task_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Work.create_task_log()

      task_log
    end

    test "list_task_logs/0 returns all task_logs" do
      task_log = task_log_fixture()
      assert Work.list_task_logs() == [task_log]
    end

    test "get_task_log!/1 returns the task_log with given id" do
      task_log = task_log_fixture()
      assert Work.get_task_log!(task_log.id) == task_log
    end

    test "create_task_log/1 with valid data creates a task_log" do
      assert {:ok, %TaskLog{} = task_log} = Work.create_task_log(@valid_attrs)
      assert task_log.duration_minutes == 42
    end

    test "create_task_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_task_log(@invalid_attrs)
    end

    test "update_task_log/2 with valid data updates the task_log" do
      task_log = task_log_fixture()
      assert {:ok, %TaskLog{} = task_log} = Work.update_task_log(task_log, @update_attrs)
      assert task_log.duration_minutes == 43
    end

    test "update_task_log/2 with invalid data returns error changeset" do
      task_log = task_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_task_log(task_log, @invalid_attrs)
      assert task_log == Work.get_task_log!(task_log.id)
    end

    test "delete_task_log/1 deletes the task_log" do
      task_log = task_log_fixture()
      assert {:ok, %TaskLog{}} = Work.delete_task_log(task_log)
      assert_raise Ecto.NoResultsError, fn -> Work.get_task_log!(task_log.id) end
    end

    test "change_task_log/1 returns a task_log changeset" do
      task_log = task_log_fixture()
      assert %Ecto.Changeset{} = Work.change_task_log(task_log)
    end
  end
end
