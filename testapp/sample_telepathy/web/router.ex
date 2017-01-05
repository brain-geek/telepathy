defmodule SampleTelepathy.Router do
  use SampleTelepathy.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SampleTelepathy do
    pipe_through :api
  end
end
