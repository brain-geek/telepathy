defmodule SampleTelepathy.InsertListenerSpec do
  use ESpec
  alias SampleTelepathy.{City,Repo,CitiesListenerAgent}

  let :changeset, do: City.changeset(%City{}, attrs())
  let :attrs, do: %{country: "some content", name: "some content"}

  before do
    CitiesListenerAgent.flush # to clear the store
    Repo.insert!(changeset())
  end

  subject do 
    Process.sleep(200)

    CitiesListenerAgent.get_messages_of(SampleTelepathy.CitiesInsertListener)
  end

  it "includes all the fields in record including autogenerated ones" do
    [message] = subject()
    expect(message["id"]).to be_integer()

    Enum.each(attrs(), fn({key, value}) ->
      k = to_string(key)

      expect(message[k]).to eq(value)
    end)
  end
end