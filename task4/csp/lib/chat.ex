use CSP

defmodule Chat do
  @moduledoc """
  Defines a Chat module that handles the creation of chat instances,
  adding and removing users, message broadcasting, and receiving messages.
  """

  # Define the Chat struct with default values for each field.
  defstruct users: [], recv_channel_pid: nil

  @doc """
  Starts a new Chat process.

  ## Returns

  A new Chat struct with a newly started and linked receive channel process.
  """
  def start do
    {:ok, pid} = Channel.start_link()
    %Chat{recv_channel_pid: pid}
  end

  @doc """
  Adds a user to the chat.

  ## Parameters

    - `chat`: The Chat struct to add a user to.
    - `user_name`: The name of the user to add.

  ## Returns

  A tuple containing the updated Chat struct and the new User struct.
  """
  def add_user(chat, user_name) do
    new_user = User.start(user_name, chat.recv_channel_pid)
    updated_users = [new_user | chat.users]
    {%{chat | users: updated_users}, new_user}
  end

  @doc """
  Removes a user from the chat.

  ## Parameters

    - `chat`: The Chat struct to remove a user from.
    - `user`: The User struct representing the user to remove.

  ## Returns

  The updated Chat struct with the user removed.
  """
  def user_delete(chat, user) do
    updated_users = Enum.reject(chat.users, fn u -> u.name == user.name end)
    %{chat | users: updated_users}
  end

  @doc """
  Broadcasts a message from a user to all users in the chat.

  ## Parameters

    - `user`: The User struct representing the sender.
    - `message`: The message text to send.
  """
  def write_message(user, message) do
    spawn(fn ->
      Channel.wrap(user.chat_channel_pid)
      |> Channel.put(%Message{username: user.name, text: message})
    end)
  end

  @doc """
  Receives messages for the chat and forwards them to all users.

  Attempts to receive a message within a 100ms timeout and, if received,
  forwards it to all users in the chat.

  ## Parameters

    - `chat`: The Chat struct to receive messages for.
  """
  def recv_messages(chat) do
    receive_and_forward_messages = fn ->
      msg = Channel.wrap(chat.recv_channel_pid)
            |> Channel.get

      Enum.each(chat.users, fn user ->
        spawn(fn ->
          Channel.wrap(user.recv_channel_pid)
          |> Channel.put(msg)
        end)
      end)
    end

    Utils.async_timeout(receive_and_forward_messages, 100)
  end
end
