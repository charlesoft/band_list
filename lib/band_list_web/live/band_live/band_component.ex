defmodule BandListWeb.BandLive.BandComponent do
  use BandListWeb, :live_component

  def render(assigns) do
    ~H"""
      <tr id={'band-#{@band.id}'}>
        <td><%= @band.name %></td>
        <td><a href="#" phx-click="like" phx-target={@myself}>
            <%=@band.likes %>
          </a>
        </td>

        <td>
          <span><%= live_redirect "Show", to: Routes.band_show_path(@socket, :show, @band) %></span>
          <span><%= live_patch "Edit", to: Routes.band_index_path(@socket, :edit, @band) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    """
  end

  def handle_event("like", _params, socket) do
    BandList.Entertainment.inc_likes(socket.assigns.band)

    {:noreply, socket}
  end
end
