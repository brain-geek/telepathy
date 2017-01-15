defmodule SampleTelepathy.CitySpec do
  use ESpec
  alias SampleTelepathy.City

  context "validity" do
    let :changeset, do: City.changeset(%City{}, attrs())
    subject do: changeset().valid?

    context "changeset with valid attributes" do
      let :attrs, do: %{country: "some content", name: "some content"}

      it "is valid" do
        is_expected().to be_truthy()
      end
    end

    context "changeset with invalid attributes" do
      let :attrs, do: %{}

      it "is invalid" do
        is_expected().to be_false()
      end
    end
  end
end