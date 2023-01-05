defmodule LiveSelectSample.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :location, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :location])
    |> validate_required([:name, :location])
  end
end
