defmodule SampleTelepathy.CitiesListener do
  require IEx
  use Telepathy.Listener, table_name: "cities"

  def handle_update(old, new, state) do
    
  end

  def handle_delete(old, state) do
    SampleTelepathy.CitiesListenerAgent.push_message(:delete, old)
    
    {:noreply, state}
  end

  def handle_insert(new, state) do
    SampleTelepathy.CitiesListenerAgent.push_message(:insert, new)
    
    {:noreply, state}
  end
end