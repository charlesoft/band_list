defmodule BandListWeb.MemberLive.Index do
  use BandListWeb, :live_view

  alias BandList.Entertainment
  alias BandList.Entertainment.Member

  @impl true
  def mount(%{"band_id" => band_id} = _params, _session, socket) do
    socket =
      socket
      |> assign(:members, list_members(band_id))
      |> assign(:band_id, band_id)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Members")
    |> assign(:member, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Member")
    |> assign(:member, %Member{})
  end

  defp apply_action(socket, :edit, %{"band_id" => band_id, "id" => id}) do
    socket
    |> assign(:page_title, "New Member")
    |> assign(:member, Entertainment.get_member!(band_id, id))
  end

  @impl true
  def handle_event("delete", %{"member" => %{"id" => id, "band_id" => band_id}}, socket) do
    member = Entertainment.get_member!(band_id, id)
    {:ok, _member} = Entertainment.delete_member(member)

    {:noreply, assign(socket, :members, list_members(band_id))}
  end

  @impl true
  def handle_info({:member_created, member}, socket) do
    {:noreply, update(socket, :members, fn members -> [member | members] end)}
  end

  defp list_members(band_id) do
    Entertainment.list_members(band_id)
  end
end
