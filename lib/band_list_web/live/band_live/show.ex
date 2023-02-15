defmodule BandListWeb.BandLive.Show do
  use BandListWeb, :live_view

  alias BandList.Entertainment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:band, Entertainment.get_band!(id))}
  end

  defp page_title(:show), do: "Show Band"
  defp page_title(:edit), do: "Edit Band"
end
