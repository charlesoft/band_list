defmodule BandListWeb.BandLive.Index do
  use BandListWeb, :live_view

  alias BandList.Entertainment
  alias BandList.Entertainment.Band

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Entertainment.subscribe()

    {:ok, assign(socket, :bands, list_bands()), temporary_assigns: [bands: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Band")
    |> assign(:band, Entertainment.get_band!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Band")
    |> assign(:band, %Band{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bands")
    |> assign(:band, nil)
  end

  @impl true
  def handle_info({:band_created, band}, socket) do
    updated_reply(socket, band)
  end

  def handle_info({:band_updated, band}, socket) do
    updated_reply(socket, band)
  end

  defp updated_reply(socket, band) do
    {:noreply, update(socket, :bands, fn bands -> [band | bands] end)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    band = Entertainment.get_band!(id)
    {:ok, _} = Entertainment.delete_band(band)

    {:noreply, assign(socket, :bands, list_bands())}
  end

  defp list_bands do
    Entertainment.list_bands()
  end
end
