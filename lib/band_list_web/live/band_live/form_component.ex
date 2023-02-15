defmodule BandListWeb.BandLive.FormComponent do
  use BandListWeb, :live_component

  alias BandList.Entertainment

  @impl true
  def update(%{band: band} = assigns, socket) do
    changeset = Entertainment.change_band(band)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"band" => band_params}, socket) do
    changeset =
      socket.assigns.band
      |> Entertainment.change_band(band_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"band" => band_params}, socket) do
    save_band(socket, socket.assigns.action, band_params)
  end

  defp save_band(socket, :edit, band_params) do
    case Entertainment.update_band(socket.assigns.band, band_params) do
      {:ok, _band} ->
        {:noreply,
         socket
         |> put_flash(:info, "Band updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_band(socket, :new, band_params) do
    case Entertainment.create_band(band_params) do
      {:ok, _band} ->
        {:noreply,
         socket
         |> put_flash(:info, "Band created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
