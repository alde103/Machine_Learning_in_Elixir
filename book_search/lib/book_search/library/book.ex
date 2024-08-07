defmodule BookSearch.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :description, :string
    field :embedding, Pgvector.Ecto.Vector
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:author, :title, :description, :embedding])
    |> validate_required([:author, :title, :description])
  end

  @doc false
  def put_embedding(%{changes: %{description: desc}} = book_changeset) do
    embedding = BookSearch.Model.predict(desc)
    put_change(book_changeset, :embedding, embedding)
  end
end
