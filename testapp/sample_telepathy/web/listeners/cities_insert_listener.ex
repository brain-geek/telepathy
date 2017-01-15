defmodule SampleTelepathy.CitiesInsertListener do
  use Telepathy.Listener, table_name: "cities"

  def handle_insert(new, state) do
    SampleTelepathy.CitiesListenerAgent.push_message(__MODULE__, new)
    
    {:noreply, state}
  end
end
