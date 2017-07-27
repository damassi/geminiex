defmodule Geminiex.Account do
  use Geminiex.Web, :model

  schema "accounts" do
    field :name, :string
    field :description, :string
    field :key, :string
    field :secret, :string

    has_many :entries, Geminiex.Entry

  end
end