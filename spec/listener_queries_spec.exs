defmodule Telepathy.ListenerQueriesSpec do
  use ESpec

  describe "#eventstream_query/1" do
    let :table_name, do: "countries"
    let :trigger_name, do: "trigger"
    let :channel_name, do: "channel_one"

    let :params, do: [table_name: table_name, trigger_name: trigger_name, channel_name: channel_name]

    subject do: described_module.eventstream_query(params)

    describe "explicit function_name" do
      let :function_name, do: "notify_telepathy_channel_one"

      it "is present in create trigger sequence" do
        expect(subject) |> to(have "EXECUTE PROCEDURE #{function_name}()")
      end

      it "is present in create function sequence" do
        expect(subject) |> to(have "CREATE OR REPLACE FUNCTION #{function_name}()")
      end
    end
  end
end