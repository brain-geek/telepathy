defmodule SampleTelepathy.UpdateListenerSpec do
  use ESpec
  alias SampleTelepathy.{City,Repo,CitiesListenerAgent}

  let :attrs, do: %{country: "some content", name: "some content"}
  let! :the_record do
    cs = City.changeset(%City{}, attrs())
    {:ok, record} = Repo.insert cs
    record
  end

  before do
    CitiesListenerAgent.flush # to clear the store
  end

  subject do 
    Process.sleep 500

    CitiesListenerAgent.get_messages_of(SampleTelepathy.CitiesUpdateListener)
  end

  context "nothing is updated" do
    it "is empty" do
      expect(subject()).to be_empty()
    end
  end

  context "one record is updated" do
    let :change, do: %{country: "other"}
    let :changeset, do: City.changeset(the_record(), change())

    before do
      Repo.update changeset()
      nil
    end

    it "includes changed fields in both maps" do
      [{old_message, new_message}] = subject()

      expect(old_message["country"]).to eq(attrs()[:country])
      expect(new_message["country"]).to eq(change()[:country])
    end

    it "includes all the unchanged fields from the deleted record in both maps" do
      [{old_message, new_message}] = subject()

      record = the_record() 
        |> Map.delete(:__struct__) 
        |> Map.delete(:__meta__)
        |> Map.delete(:updated_at)
        |> Map.delete(:country)

      Enum.each(record, fn({key, value}) ->
        k = to_string(key)
        
        expect(old_message[k]). to eq(new_message[k])

        case value do
          %NaiveDateTime{} -> 
            expect(NaiveDateTime.to_iso8601(value)).to have(old_message[k])
          _ -> 
            expect(old_message[k]).to eq(value)
        end
      end)
    end
  end
end