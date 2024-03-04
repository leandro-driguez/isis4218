defmodule ChatUser do
  @moduledoc """
  Manages chat users, handling sending and receiving messages through file monitoring.
  Each user has dedicated processes for sending and receiving messages.
  """

  # Starts a user process and initializes the user's directory and files.
  def start_user(name) do
    user_dir = "chat_room/#{name}"
    File.mkdir_p(user_dir)

    # Ensure the send and receive files exist.
    File.write("#{user_dir}/send.txt", "", [:write])
    File.write("#{user_dir}/receive.txt", "", [:write])

    # Spawn processes for sending and receiving messages.
    send_pid = spawn(fn -> send_loop(name, "#{user_dir}/send.txt") end)
    receive_pid = spawn(fn -> receive_loop(name, "#{user_dir}/receive.txt") end)

    # Return a map with user details.
    %{name: name, send_pid: send_pid, receive_pid: receive_pid}
  end

  # Private function to handle the sending messages loop.
  defp send_loop(user_name, send_file_path) do
    send_message = fn ->
      # Read the send file and broadcast any messages found.
      case File.read(send_file_path) do
        {:ok, message} when message != "" ->
          # Placeholder: Actual implementation to fetch user list goes here.
          user_list = ChatRoom.get_all_users() # This function needs to be implemented or adjusted.

          # Broadcast the message to all users.
          Enum.each(user_list, fn user ->
            Inbox.insert_message(user, "#{user_name}: #{message}")
          end)

          # Clear the send file after broadcasting messages.
          File.write(send_file_path, "")
        _ -> :ok
      end
    end

    # Loop to continuously check for and send new messages.
    loop = fn loop_fun ->
      send_message.()
      :timer.sleep(500) # Check every 500ms.
      loop_fun.(loop_fun)
    end

    loop.(loop)
  end

  # Private function to handle the receiving messages loop.
  defp receive_loop(user_name, receive_file_path) do
    receive_messages = fn ->
      # Fetch messages for the user.
      messages = Inbox.get_messages(user_name)

      # Append each message to the receive file.
      Enum.each(messages, fn message ->
        File.write(receive_file_path, "#{message}\n", [:append])
      end)
    end

    # Loop to continuously check for and write new messages.
    loop = fn loop_fun ->
      receive_messages.()
      :timer.sleep(1000) # Check every 1000ms.
      loop_fun.(loop_fun)
    end

    loop.(loop)
  end
end
