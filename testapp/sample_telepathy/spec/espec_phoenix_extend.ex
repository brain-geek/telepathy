defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias SampleTelepathy.Repo
    end
  end

  def controller do
    quote do
      alias SampleTelepathy
      import SampleTelepathy.Router.Helpers

      @endpoint SampleTelepathy.Endpoint
    end
  end

  def view do
    quote do
      import SampleTelepathy.Router.Helpers
    end
  end

  def channel do
    quote do
      alias SampleTelepathy.Repo

      @endpoint SampleTelepathy.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
