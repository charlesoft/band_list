defmodule BandList.Entertainment do
  @moduledoc """
  The Entertainment context.
  """

  import Ecto.Query, warn: false
  alias BandList.Repo

  alias BandList.Entertainment.{Band, Member}

  @doc """
  Returns the list of bands.

  ## Examples

      iex> list_bands()
      [%Band{}, ...]

  """
  def list_bands do
    query = from(b in Band)

    query
    |> order_by([b], desc: b.name)
    |> Repo.all()
  end

  def list_members(band_id) do
    query = from(m in Member)

    query
    |> where([m], m.band_id == ^band_id)
    |> order_by([m], desc: m.name)
    |> Repo.all()
  end

  @doc """
  Gets a single band.

  Raises `Ecto.NoResultsError` if the Band does not exist.

  ## Examples

      iex> get_band!(123)
      %Band{}

      iex> get_band!(456)
      ** (Ecto.NoResultsError)

  """
  def get_band!(id), do: Repo.get!(Band, id)

  def get_member!(band_id, id) do
    query = from(m in Member)

    query
    |> where([m], m.id == ^id and m.band_id == ^band_id)
    |> Repo.one!()
  end

  @doc """
  Creates a band.

  ## Examples

      iex> create_band(%{field: value})
      {:ok, %Band{}}

      iex> create_band(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_band(attrs \\ %{}) do
    %Band{}
    |> Band.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:band_created, "bands")
  end

  def create_member(attrs) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:member_created, "members")
  end

  @doc """
  Updates a band.

  ## Examples

      iex> update_band(band, %{field: new_value})
      {:ok, %Band{}}

      iex> update_band(band, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_band(%Band{} = band, attrs) do
    band
    |> Band.changeset(attrs)
    |> Repo.update()
    |> broadcast(:band_updated, "bands")
  end

  @doc """
  Deletes a band.

  ## Examples

      iex> delete_band(band)
      {:ok, %Band{}}

      iex> delete_band(band)
      {:error, %Ecto.Changeset{}}

  """
  def delete_band(%Band{} = band) do
    Repo.delete(band)
  end

  def delete_member(member) do
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking band changes.

  ## Examples

      iex> change_band(band)
      %Ecto.Changeset{data: %Band{}}

  """
  def change_band(%Band{} = band, attrs \\ %{}) do
    Band.changeset(band, attrs)
  end

  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end

  def subscribe(data) do
    Phoenix.PubSub.subscribe(BandList.PubSub, data)
  end

  def inc_likes(%Band{id: id}) do
    query = from(b in Band)

    {1, [band]} =
      query
      |> where([b], b.id == ^id)
      |> select([b], b)
      |> Repo.update_all(inc: [likes: 1])

    broadcast({:ok, band}, :band_updated)
  end

  defp broadcast({:error, error}, _event), do: error

  defp broadcast({:ok, data}, event, name) do
    Phoenix.PubSub.broadcast(BandList.PubSub, name, {event, data})

    {:ok, data}
  end
end
