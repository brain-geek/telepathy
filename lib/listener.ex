defmodule Telepathy.Listener do
  require IEx
  defmacro __using__(params) do
    table_name = Keyword.fetch!(params, :table_name)

    quote do
      @table_name unquote(table_name)
      use GenServer

      ## Client API

      @doc """
      Starts the listener.
      """
      def start_link(db_connection) do
        GenServer.start_link(__MODULE__, db_connection, [])
      end

      ## Callback API interface

      def handle_update(_old, _new, state) do
        {:noreply, state}
      end

      def handle_delete(_old, state) do
        {:noreply, state}
      end
      
      def handle_insert(_new, state) do
        {:noreply, state}
      end

      defoverridable [handle_update: 3, handle_delete: 2, handle_insert: 2]

      ## GenServer Callbacks

      def init(db_connection) do
        {:ok, pg_pid}    = Postgrex.start_link(db_connection)
        {:ok, notif_pid} = Postgrex.Notifications.start_link(db_connection)

        queries = Telepathy.ListenerQueries.eventstream_query table_name: @table_name, trigger_name: trigger_name(), channel_name: channel_name()

        queries |> Enum.each(fn(query) -> 
          {:ok, _} = Postgrex.query pg_pid, query, []
        end)

        Postgrex.Notifications.listen(notif_pid, "cities")

        {:ok, %{notif_pid: notif_pid, pg_pid: pg_pid}}
      end

      def handle_info(raw_msg, state) do
        msg = Poison.decode! elem(raw_msg, 4)

        case msg["type"] do
          "INSERT" -> 
            handle_insert(msg["new_data"], state)
          "DELETE" ->
            handle_delete(msg["old_data"], state)
          "UPDATE" -> 
            handle_update(msg["old_data"], msg["new_data"], state)
        end
      end

      ## Helpers

      defp trigger_name do
        "notify_" <> @table_name <> "_changes_trg"
      end

      defp channel_name do
        @table_name
      end
    end
  end
end