defmodule SampleTelepathy.CitiesDeleteListener do
  use Telepathy.Listener, table_name: "cities"
  
  def handle_delete(old, state) do
    SampleTelepathy.CitiesListenerAgent.push_message(__MODULE__, old)
    
    {:noreply, state}
  end
end