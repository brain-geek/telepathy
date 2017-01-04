defmodule SampleTelepathy.ErrorViewTest do
  use SampleTelepathy.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(SampleTelepathy.ErrorView, "404.json", []) ==
           %{errors: %{detail: "Page not found"}}
  end

  test "render 500.json" do
    assert render(SampleTelepathy.ErrorView, "500.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end

  test "render any other" do
    assert render(SampleTelepathy.ErrorView, "505.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end
end
