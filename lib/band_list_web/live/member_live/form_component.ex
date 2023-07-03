defmodule BandListWeb.MemberLive.FormComponent do
  use BandListWeb, :live_component

  alias BandList.Entertainment

  @impl true
  def update(%{member: member} = assigns, socket) do
    changeset = Entertainment.change_member(member)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"member" => member_params}, socket) do
    changeset =
      socket.assigns.member
      |> Entertainment.change_member(member_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"member" => member_params}, socket) do
    case Entertainment.create_member(member_params) do
      {:ok, _member} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Member created!")
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
