defmodule Telepathy.Listener do
  require IEx
  defmacro __using__(_) do
    require IEx
    quote do
      @table_name "cities"
      use GenServer

      ## Client API

      @doc """
      Starts the listener.
      """
      def start_link(db_connection) do
        GenServer.start_link(__MODULE__, db_connection, [])
      end

      ## Server Callbacks

      def init(db_connection) do
        # IEx.pry
        {:ok, pg_pid}    = Postgrex.start_link(db_connection)
        {:ok, notif_pid} = Postgrex.Notifications.start_link(db_connection)

        the_query = Telepathy.ListenerQueries.eventstream_query table_name: @table_name, trigger_name: trigger_name, channel_name: channel_name
        queries = String.split the_query, ";"

        queries |> Enum.each(fn(query) -> 
          {:ok, _} = Postgrex.query pg_pid, query, []
        end)

        Postgrex.Notifications.listen(notif_pid, "cities")

        IO.puts "started"

        {:ok, %{notif_pid: notif_pid, pg_pid: pg_pid}}
      end

      def handle_info(msg, state) do
        db_msg = elem(msg, 4)

        parsed_msg = Poison.decode! db_msg

        GenServer.cast(self, {parsed_msg["type"], parsed_msg})

        {:noreply, state}
      end

      def handle_cast({"INSERT", msg = %{}}, state) do
        handle_insert(msg["new_data"], state)
      end

      def handle_cast({"DELETE", msg = %{}}, state) do
        
        
        {:noreply, state}
      end

      def handle_cast({"UPDATE", msg = %{}}, state) do
        
        
        {:noreply, state}
      end

      defp trigger_name do
        "notify_" <> @table_name <> "_changes_trg"
      end

      defp channel_name do
        @table_name
      end
    end
  end
end