defmodule Geminiex.Entry do
  use Geminiex.Web, :model

  schema "entries" do
    field :token, :string

    belongs_to  :template, Geminiex.Template
    belongs_to  :account, Geminiex.Account
    field   :source_key, :string
    field   :source_bucket, :string
    field   :metadata, :map
    field   :source_url, :string
    field   :extract_geometry, :boolean, default: false
    field   :geometry, :map
    field   :properties, :map
    field   :exif, :map
    field   :skip_watermark, :boolean, default: false
    field   :low_priority, :boolean,   default: false

  end

  @required_fields ~w(token template_id account_id source_key source_bucket)
  @optional_fields ~w(source_url extract_geometry geometry properties exif skip_watermark low_priority)


  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:template_id)
  end
end