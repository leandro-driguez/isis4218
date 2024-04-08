use CSP

defmodule User do
  @moduledoc """
  Defines a User within a chat application, capable of receiving messages from a chat channel.
  """

  # Define the User struct with default values for each field.
  defstruct messages: [], name: "", recv_channel_pid: nil, chat_channel_pid: nil

  @doc """
  Starts a new User process linked to a chat channel.

  ## Parameters

    - `user_name`: The name of the user.
    - `chat_channel_pid`: The PID of the chat channel this user is connected to.

  ## Returns

  A new User struct initialized with the provided `user_name` and `chat_channel_pid`,
  and with a new receive channel process started and linked.
  """
  def start(user_name, chat_channel_pid) do
    {:ok, pid} = Channel.start_link()

    %User{
      name: user_name,
      chat_channel_pid: chat_channel_pid,
      recv_channel_pid: pid,
    }
  end

  @doc """
  Receives a message for the user, with a timeout.

  Attempts to receive a message from the user's `recv_channel_pid` within a 100ms timeout.
  If a message is received within the timeout, it is added to the user's `messages`.
  If no message is received, the user's state is returned unchanged.

  ## Parameters

    - `user`: The User struct to receive a message for.

  ## Returns

  The updated User struct with the received message, if any.
  """
  def recv_msg(user) do
    receive_message = fn ->
      user.recv_channel_pid
      |> Channel.wrap
      |> Channel.get
    end

    # Utilize Utils.async_timeout/2 to attempt receiving a message with a 100ms timeout.
    case Utils.async_timeout(receive_message, 100) do
      nil -> user
      msg -> update_user_messages(user, msg)
    end
  end

  # Helper function to append a received message to the user's messages list.
  defp update_user_messages(user, msg) do
    %{user | messages: user.messages ++ [msg]}
  end
end
