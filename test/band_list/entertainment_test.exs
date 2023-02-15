defmodule BandList.EntertainmentTest do
  use BandList.DataCase

  alias BandList.Entertainment

  describe "bands" do
    alias BandList.Entertainment.Band

    import BandList.EntertainmentFixtures

    @invalid_attrs %{name: nil}

    test "list_bands/0 returns all bands" do
      band = band_fixture()
      assert Entertainment.list_bands() == [band]
    end

    test "get_band!/1 returns the band with given id" do
      band = band_fixture()
      assert Entertainment.get_band!(band.id) == band
    end

    test "create_band/1 with valid data creates a band" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Band{} = band} = Entertainment.create_band(valid_attrs)
      assert band.name == "some name"
    end

    test "create_band/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entertainment.create_band(@invalid_attrs)
    end

    test "update_band/2 with valid data updates the band" do
      band = band_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Band{} = band} = Entertainment.update_band(band, update_attrs)
      assert band.name == "some updated name"
    end

    test "update_band/2 with invalid data returns error changeset" do
      band = band_fixture()
      assert {:error, %Ecto.Changeset{}} = Entertainment.update_band(band, @invalid_attrs)
      assert band == Entertainment.get_band!(band.id)
    end

    test "delete_band/1 deletes the band" do
      band = band_fixture()
      assert {:ok, %Band{}} = Entertainment.delete_band(band)
      assert_raise Ecto.NoResultsError, fn -> Entertainment.get_band!(band.id) end
    end

    test "change_band/1 returns a band changeset" do
      band = band_fixture()
      assert %Ecto.Changeset{} = Entertainment.change_band(band)
    end
  end
end
