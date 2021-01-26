defmodule TaskTrackerServer.Repo do
  use Ecto.Repo,
    otp_app: :task_tracker_server,
    adapter: Ecto.Adapters.Postgres
end
