defmodule BandListWeb.MemberLive.Index do
  use BandListWeb, :live_view

  alias BandList.Entertainment

  @impl true
  def mount(%{"band_id" => band_id} = _params, _session, socket) do
    {:ok, assign(socket, :members, Entertainment.list_members(band_id))}
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
end