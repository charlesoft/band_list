defmodule BandList.Repo.Migrations.AddBioStartDateEndDateToMembers do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :bio, :string, null: false
      add :start_date, :utc_datetime, null: false
      add :end_date, :utc_datetime
    end
  end
end
