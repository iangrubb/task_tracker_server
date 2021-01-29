defmodule TaskTrackerServer.Work do
  @moduledoc """
  The Work context.
  """

  import Ecto.Query, warn: false
  alias TaskTrackerServer.Repo

  alias TaskTrackerServer.Work.TaskLog

  @doc """
  Returns the list of task_logs.

  ## Examples

      iex> list_task_logs()
      [%TaskLog{}, ...]

  """
  def list_task_logs do
    Repo.all(TaskLog)
  end

  @doc """
  Gets a single task_log.

  Raises `Ecto.NoResultsError` if the Task log does not exist.

  ## Examples

      iex> get_task_log!(123)
      %TaskLog{}

      iex> get_task_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_log!(id), do: Repo.get!(TaskLog, id)

  @doc """
  Creates a task_log.

  ## Examples

      iex> create_task_log(%{field: value})
      {:ok, %TaskLog{}}

      iex> create_task_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_log(attrs \\ %{}) do
    %TaskLog{}
    |> TaskLog.changeset(attrs)
    |> Repo.insert()
  end

  def task_log_with_belongs(task_log_id) do
    TaskLog
    |> Repo.get!(task_log_id)
    |> Repo.preload([task: [project: :customer]])
  end

  def get_current_task_log(user_id) do

    query =
      from t in TaskLog,
      where: t.user_id == ^user_id,
      where: is_nil(t.end_time),
      limit: 1

    Repo.one(query)
  end

  def start_task_log(attrs \\ %{}) do
    %TaskLog{}
    |> TaskLog.changeset(Map.put(attrs, "start_time", NaiveDateTime.local_now()))
    |> Repo.insert()
  end

  def finish_task_log(%TaskLog{} = task_log) do
    task_log
    |> TaskLog.changeset(%{end_time: NaiveDateTime.local_now()})
    |> Repo.update()
  end

  @doc """
  Updates a task_log.

  ## Examples

      iex> update_task_log(task_log, %{field: new_value})
      {:ok, %TaskLog{}}

      iex> update_task_log(task_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_log(%TaskLog{} = task_log, attrs) do
    task_log
    |> TaskLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task_log.

  ## Examples

      iex> delete_task_log(task_log)
      {:ok, %TaskLog{}}

      iex> delete_task_log(task_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_log(%TaskLog{} = task_log) do
    Repo.delete(task_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_log changes.

  ## Examples

      iex> change_task_log(task_log)
      %Ecto.Changeset{data: %TaskLog{}}

  """
  def change_task_log(%TaskLog{} = task_log, attrs \\ %{}) do
    TaskLog.changeset(task_log, attrs)
  end
end
