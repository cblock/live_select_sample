defmodule LiveSelectSampleWeb.PersonLive.FormComponent do
  use LiveSelectSampleWeb, :live_component
  import LiveSelect

  alias LiveSelectSample.People

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <%!-- <.input field={{f, :location}} type="text" label="location" /> --%>
        <%= live_select(f, :location) %>
        <:actions>
          <.button phx-disable-with="Saving...">Save Person</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_info(
        %LiveSelect.ChangeMsg{
          id: "person_location_component",
          field: :location,
          text: text,
          module: LiveSelect.Component
        } = change_msg,
        socket
      ) do
    locations = ["city name 1", "city name 2"]
    # cities could be:
    # [ {"city name 1", [lat_1, long_1]}, {"city name 2", [lat_2, long_2]}, ... ]
    #
    # but it could also be (no coordinates in this case):
    # [ "city name 1", "city name 2", ... ]
    #
    # or:
    # [ [label: "city name 1", value: [lat_1, long_1]], [label: "city name 2", value: [lat_2, long_2]], ... ]
    #
    # or even:
    # ["city name 1": [lat_1, long_1], "city name 2": [lat_2, long_2]]

    update_options(change_msg, locations)

    {:noreply, socket}
  end

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = People.change_person(person)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      socket.assigns.person
      |> People.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case People.update_person(socket.assigns.person, person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_person(socket, :new, person_params) do
    case People.create_person(person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
