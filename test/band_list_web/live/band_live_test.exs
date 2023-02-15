defmodule BandListWeb.BandLiveTest do
  use BandListWeb.ConnCase

  import Phoenix.LiveViewTest
  import BandList.EntertainmentFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_band(_) do
    band = band_fixture()
    %{band: band}
  end

  describe "Index" do
    setup [:create_band]

    test "lists all bands", %{conn: conn, band: band} do
      {:ok, _index_live, html} = live(conn, Routes.band_index_path(conn, :index))

      assert html =~ "Listing Bands"
      assert html =~ band.name
    end

    test "saves new band", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.band_index_path(conn, :index))

      assert index_live |> element("a", "New Band") |> render_click() =~
               "New Band"

      assert_patch(index_live, Routes.band_index_path(conn, :new))

      assert index_live
             |> form("#band-form", band: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#band-form", band: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.band_index_path(conn, :index))

      assert html =~ "Band created successfully"
      assert html =~ "some name"
    end

    test "updates band in listing", %{conn: conn, band: band} do
      {:ok, index_live, _html} = live(conn, Routes.band_index_path(conn, :index))

      assert index_live |> element("#band-#{band.id} a", "Edit") |> render_click() =~
               "Edit Band"

      assert_patch(index_live, Routes.band_index_path(conn, :edit, band))

      assert index_live
             |> form("#band-form", band: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#band-form", band: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.band_index_path(conn, :index))

      assert html =~ "Band updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes band in listing", %{conn: conn, band: band} do
      {:ok, index_live, _html} = live(conn, Routes.band_index_path(conn, :index))

      assert index_live |> element("#band-#{band.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#band-#{band.id}")
    end
  end

  describe "Show" do
    setup [:create_band]

    test "displays band", %{conn: conn, band: band} do
      {:ok, _show_live, html} = live(conn, Routes.band_show_path(conn, :show, band))

      assert html =~ "Show Band"
      assert html =~ band.name
    end

    test "updates band within modal", %{conn: conn, band: band} do
      {:ok, show_live, _html} = live(conn, Routes.band_show_path(conn, :show, band))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Band"

      assert_patch(show_live, Routes.band_show_path(conn, :edit, band))

      assert show_live
             |> form("#band-form", band: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#band-form", band: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.band_show_path(conn, :show, band))

      assert html =~ "Band updated successfully"
      assert html =~ "some updated name"
    end
  end
end
