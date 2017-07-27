defmodule Geminiex.Router do
  use Geminiex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Geminiex.AuthPlug, repo: Geminiex.Repo
  end

  scope "/", Geminiex do
    pipe_through :api

    get "/crop", EntriesController, :crop
  end
end
