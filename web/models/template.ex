defmodule Geminiex.Template do
  use Geminiex.Web, :model

  schema "templates" do
    field :key, :string
    field :description, :string, length: 255

    belongs_to :account, Geminiex.Account
    has_many :entries, Geminieex.Entry

  end

  @required_fields ~w(key)
  @optional_fields ~w(description)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:account_id)
  end
end