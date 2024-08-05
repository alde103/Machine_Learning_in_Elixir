defmodule BookSearch.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :author, :string
      add :title, :string
      add :description, :text
      add :embedding, :vector, size: 384

      timestamps(type: :utc_datetime)
    end
  end
end
