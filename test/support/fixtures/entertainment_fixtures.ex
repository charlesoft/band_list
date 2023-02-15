defmodule BandList.EntertainmentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BandList.Entertainment` context.
  """

  @doc """
  Generate a band.
  """
  def band_fixture(attrs \\ %{}) do
    {:ok, band} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> BandList.Entertainment.create_band()

    band
  end
end
