defmodule BandList.Entertainment.Band do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bands" do
    field :name, :string
    field :likes, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(band, attrs) do
    band
    |> cast(attrs, [:name, :likes])
    |> validate_required([:name, :likes])
    |> validate_length(:name, min: 2, max: 30)
  end
end
