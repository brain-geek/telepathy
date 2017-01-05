defmodule CitiesListener do
  require IEx
  use Telepathy.Listener, table_name: "cities"

  def handle_update(old, new, state) do
    
  end

  def handle_delete(old, state) do
    
  end

  def handle_insert(new, state) do
    IO.puts "Received an update"
    IO.inspect new
    
    {:noreply, state}
  end
end