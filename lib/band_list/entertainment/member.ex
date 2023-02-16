defmodule BandList.Enterteinment.Member do
  use Ecto.Schema
  import Ecto.Changeset

  alias BandList.Entertainment.Band

  schema "members" do
    field :name, :string
    field :bio, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    belongs_to :band, Band

    timestamps()
  end

  @doc false
  def changeset(member, attrs \\ %{}) do
    member
    |> cast(attrs, [:name, :bio, :start_date, :end_date])
    |> validate_required([:name, :bio, :start_date, :band_id])
  end
end