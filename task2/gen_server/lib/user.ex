defmodule User do
  use GenServer

  @moduledoc """
  Represents a user in the chat application.

  This GenServer module handles user-related actions such as subscribing to a chat room,
  posting messages, and managing received messages.
  """

  @doc """
  Starts a linked GenServer process for a user.

  ## Parameters
  - name: The name of the user as a string.
  - chat_room: The PID of the chat room to which the user will be subscribed.

  ## Returns
  - A tuple {:ok, pid} on success, where pid is the PID of the started GenServer process.
  """
  def start_link(name, chat_room) do
    GenServer.start_link(__MODULE__, %{name: name, chat_room: chat_room, received_messages: []}, name: String.to_atom(name))
  end

  @doc """
  Initializes the user process.

  Subscribes the user to the specified chat room upon initialization.

  ## Parameters
  - state: The initial state passed to the GenServer process.

  ## Returns
  - A tuple {:ok, state}, indicating successful initialization.
  """
  def init(state) do
    ChatRoom.subscribe(state.chat_room, self())
    {:ok, state}
  end

  @doc """
  Stops the user process.

  ## Parameters
  - user_pid: The PID of the user process to be stopped.

  ## Returns
  - :ok after the user is unsubscribed and the process is stopped.
  """
  def stop(user_pid) do
    GenServer.call(user_pid, :stop)
  end

  @doc """
  Posts a message from the user to the chat room.

  ## Parameters
  - user_pid: The PID of the user sending the message.
  - message: The message string to be sent.

  ## Returns
  - :ok if the message was sent successfully.
  """
  def post_message(user_pid, message) do
    GenServer.cast(user_pid, {:post_message, message})
  end

  # Handles synchronous call to stop the user process.
  def handle_call(:stop, _from, state) do
    ChatRoom.unsubscribe(state.chat_room, self())
    {:stop, :normal, :ok, state}
  end

  # Handles asynchronous request to post a message.
  def handle_cast({:post_message, message}, %{name: name, chat_room: chat_room} = state) do
    ChatRoom.send_message(chat_room, "#{name}: #{message}")
    {:noreply, state}
  end

  # Handles incoming messages for the user.
  def handle_info({:new_message, message}, %{received_messages: messages} = state) do
    updated_messages = [message | messages]

    # Logs received messages to a file.
    File.write("chat_logs/#{state.name}_messages.txt", Enum.reverse(updated_messages) |> Enum.join("\n"))

    {:noreply, %{state | received_messages: updated_messages}}
  end
end
