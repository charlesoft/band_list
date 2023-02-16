defmodule BandList.Repo.Migrations.CreateTableMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string, null: false
      add :band_id, references(:bands, on_delete: :nothing)

      timestamps()
    end
  end
end
