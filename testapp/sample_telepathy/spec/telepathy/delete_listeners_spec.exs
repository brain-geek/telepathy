defmodule SampleTelepathy.SimpleDeleteSpec do
  use ESpec
  alias SampleTelepathy.{City,Repo,CitiesListenerAgent}

  context "insert" do
    let :attrs_first, do: %{country: "some content", name: "some content"}
    let! :record_first do
      cs = City.changeset(%City{}, attrs_first)
      {:ok, record} = Repo.insert cs
      record
    end

    let :attrs_second, do: %{name: "Atlantis"}
    let! :record_second do
      cs = City.changeset(%City{}, attrs_second)
      {:ok, record} = Repo.insert cs
      record
    end

    before do
      CitiesListenerAgent.flush # to clear the store
    end

    subject do 
      Process.sleep 500

      CitiesListenerAgent.flush |> Enum.filter(&(elem(&1, 0) == :delete))
    end

    context "nothing is deleted" do
      it "is empty" do
        expect(subject).to be_empty
      end
    end

    context "one record is deleted" do
      before do
        Repo.delete record_first
        nil
      end

      it "has one element in queue with correct type" do
        [{type, _message}] = subject
        expect(type).to eq(:delete)
      end

      it "includes all the fields from the deleted record" do
        [{_type, message_map}] = subject

        record = record_first |> Map.delete(:__struct__) |> Map.delete(:__meta__)

        Enum.each(record, fn({key, value}) ->
          k = to_string(key)
          msg_value = message_map[k]

          value = case value do
            %NaiveDateTime{} -> NaiveDateTime.to_iso8601(value)
            _ -> value
          end

          expect(msg_value).to eq(value)
        end)
      end
    end
  end
end