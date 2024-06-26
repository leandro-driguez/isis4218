defmodule ChatRoom do
  use GenServer

  @moduledoc """
  A GenServer-based ChatRoom implementation that supports subscribing and unsubscribing processes,
  and broadcasting messages to all subscribers.
  """

  # Starts a GenServer process for the ChatRoom with initial state
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{subscribers: %{}, messages: []}, opts)
  end

  # Initializes the GenServer state
  def init(initial_state) do
    {:ok, initial_state}
  end

  @doc """
  Subscribes a process to the chat room.

  ## Parameters
  - room: The PID or name of the ChatRoom GenServer.
  - pid: The PID of the subscribing process.
  """
  def subscribe(room, pid) do
    GenServer.call(room, {:subscribe, pid})
  end

  @doc """
  Unsubscribes a process from the chat room.

  ## Parameters
  - room: The PID or name of the ChatRoom GenServer.
  - pid: The PID of the unsubscribing process.
  """
  def unsubscribe(room, pid) do
    GenServer.cast(room, {:unsubscribe, pid})
  end

  @doc """
  Sends a message to all subscribers of the chat room.

  ## Parameters
  - room: The PID or name of the ChatRoom GenServer.
  - message: The message to be sent.
  """
  def send_message(room, message) do
    GenServer.cast(room, {:send_message, message})
  end

  # Callbacks

  def handle_call({:subscribe, pid}, _from, state = %{subscribers: subscribers, messages: messages}) do
    new_subscribers = Map.put(subscribers, pid, length(messages))
    {:reply, :ok, %{state | subscribers: new_subscribers}}
  end

  def handle_cast({:unsubscribe, pid}, state = %{subscribers: subscribers}) do
    new_subscribers = Map.delete(subscribers, pid)
    {:noreply, %{state | subscribers: new_subscribers}}
  end

  def handle_cast({:send_message, message}, state = %{subscribers: subscribers, messages: messages}) do
    updated_messages = messages ++ [message]

    Enum.each(subscribers, fn {pid, _start_index} ->
      send(pid, {:new_message, message})
    end)

    {:noreply, %{state | messages: updated_messages}}
  end
end
