defmodule SampleTelepathy.CitiesListenerAgent do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  # @doc Pushes message for given receiver to queue
  def push_message(type, message) do
    item = {type, message}
    Agent.update(__MODULE__, &( [item | &1 ]))
  end

  def get_messages_of(type) do
    Agent.get(__MODULE__, fn set ->
      Enum.filter(set, &( elem(&1, 0) == type ))
    end)
    |> Enum.map(&(elem(&1, 1)))
  end

  # @doc Gets all messages, empties the queue
  def flush do
    Agent.get_and_update(__MODULE__, &( {&1, []} ))
  end
end