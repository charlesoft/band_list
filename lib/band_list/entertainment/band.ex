defmodule BandList.Entertainment.Band do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bands" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(band, attrs) do
    band
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 30)
  end
end
