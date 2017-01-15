defmodule SampleTelepathy.DeleteListenerSpec do
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

    CitiesListenerAgent.get_messages_of(SampleTelepathy.CitiesDeleteListener)
  end

  context "nothing is deleted" do
    it "is empty" do
      expect(subject()).to be_empty()
    end
  end

  context "one record is deleted" do
    before do
      Repo.delete the_record()
      nil
    end

    it "includes all the fields from the deleted record" do
      [message_map] = subject()

      record = the_record() 
        |> Map.delete(:__struct__) 
        |> Map.delete(:__meta__)

      Enum.each(record, fn({key, value}) ->
        k = to_string(key)
        msg_value = message_map[k]

        case value do
          %NaiveDateTime{} -> 
            expect(msg_value).to eq(NaiveDateTime.to_iso8601(value))
          _ -> 
            expect(msg_value).to eq(value)
        end      
      end)
    end
  end
end