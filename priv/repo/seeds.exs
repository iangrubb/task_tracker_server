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

alias TaskTrackerServer.Customers
alias TaskTrackerServer.Projects

Enum.each(1..5, fn _ ->
  with {:ok, customer} <- Customers.create_customer(%{name: Faker.Company.name()}) do
    Enum.each(1..5, fn _ ->
      with {:ok, project} <-
             Projects.create_project(%{name: Faker.Company.bs(), customer_id: customer.id}) do
        Enum.each(1..10, fn _ ->
          Projects.create_task(%{description: Faker.Company.bs(), project_id: project.id})
        end)
      end
    end)
  end
end)
