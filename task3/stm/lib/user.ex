defmodule User do
  @moduledoc """
  Manages chat users by monitoring files for sending and receiving messages.
  Each user is represented by a process for sending messages and another for receiving them,
  with their communication mediated through file operations.
  """

  @doc """
  Creates a new user with the given name, setting up their messaging environment.

  ## Parameters

  - name: The name of the user to create.

  ## Returns

  A map containing the user's name, message list, and PIDs for send and receive loops.
  """
  def create_user(name) do
    user_dir = "chat_room/#{name}"
    File.mkdir_p(user_dir)

    # Ensure the send and receive files exist.
    File.write("#{user_dir}/send.txt", "")
    File.write("#{user_dir}/receive.txt", "")

    # Spawn processes for sending and receiving messages.
    send_pid = spawn(fn -> send_loop(name, "#{user_dir}/send.txt") end)
    receive_pid = spawn(fn -> receive_loop(name, "#{user_dir}/receive.txt") end)

    %{name: name, messages: [], send_pid: send_pid, receive_pid: receive_pid}
  end

  defp send_loop(user_name, send_file_path) do
    send_message = fn ->
      case File.read(send_file_path) do
        {:ok, message} when message != "" ->
          Chat.write_message(user_name, message)
          File.write(send_file_path, "")
        _ -> :ok
      end
    end

    repeat(send_message, 500)
  end

  defp receive_loop(user_name, receive_file_path) do
    receive_messages = fn ->
      case Chat.get_user_messages(user_name) do
        {:ok, messages} ->
          # Open the file, clearing it before writing new messages.
          messages = Enum.reverse(messages)
          content = Enum.map_join(messages, "\n", fn {sender, message} ->
            "#{sender}: #{message}"
          end)
          File.write(receive_file_path, content)
        _ -> :ok
      end
    end

    repeat(receive_messages, 1000)
  end

  # Helper function to repeat a given action at specified intervals.
  defp repeat(action, interval) do
    loop = fn loop_fun ->
      action.()
      :timer.sleep(interval)
      loop_fun.(loop_fun)
    end

    loop.(loop)
  end
end
