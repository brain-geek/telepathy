defmodule SampleTelepathy.Repo.Migrations.CreateCity do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :country, :string

      timestamps()
    end

  end
end
