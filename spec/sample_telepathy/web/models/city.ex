defmodule SampleTelepathy.City do
  use SampleTelepathy.Web, :model

  schema "cities" do
    field :name, :string
    field :country, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :country])
    |> validate_required([:name, :country])
  end
end
