defmodule LiveSelectSample.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSelectSample.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        location: "some location",
        name: "some name"
      })
      |> LiveSelectSample.People.create_person()

    person
  end
end
