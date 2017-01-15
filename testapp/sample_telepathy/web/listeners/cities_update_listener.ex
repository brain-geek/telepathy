defmodule SampleTelepathy.CitiesUpdateListener do
  use Telepathy.Listener, table_name: "cities"

  def handle_update(old, new, state) do
    SampleTelepathy.CitiesListenerAgent.push_message(__MODULE__, {old, new})
    
    {:noreply, state}
  end
end
