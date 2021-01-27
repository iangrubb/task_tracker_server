# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskTrackerServer.Repo.insert!(%TaskTrackerServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaskTrackerServer.Accounts
alias TaskTrackerServer.Customers
alias TaskTrackerServer.Projects
alias TaskTrackerServer.Work

Enum.each(1..10, fn _ ->
  Accounts.create_user(%{name: Faker.Person.first_name() <> " " <> Faker.Person.last_name() , password_hash: "test"})
end)

users = Accounts.list_users()

Enum.each(1..5, fn _ ->
  with {:ok, customer} <- Customers.create_customer(%{name: Faker.Company.name()}) do
    Enum.each(1..5, fn _ ->
      with {:ok, project} <- Projects.create_project(%{name: Faker.Company.bs(), company_id: customer.id}) do
        Enum.each(1..10, fn _ ->
          with {:ok, task} <- Projects.create_task(%{description: Faker.Company.bs(), project_id: project.id}) do
            Enum.each(1..10, fn _ ->
              Work.create_task_log(%{user_id: Enum.random(users).id, task_id: task.id, duration_minutes: Enum.random(15..120)})
            end)
          end
        end)
      end
    end)
  end
end)
