defmodule BandList.Repo.Migrations.AddLikesToBands do
  use Ecto.Migration

  def change do
    alter table(:bands) do
      add :likes, :integer, default: 0
    end
  end
end
