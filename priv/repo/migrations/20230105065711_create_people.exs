defmodule LiveSelectSample.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string
      add :location, :string

      timestamps()
    end
  end
end
