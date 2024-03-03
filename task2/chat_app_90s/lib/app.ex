defmodule App do
  @moduledoc """
  Defines the main application module for a chat room.
  This module handles the initialization and command processing for the chat application.
  """

  use Application
  def start(_type, _args) do
    {:ok, self()}
  end

  @doc """
  Starts the chat application.

  Creates a "chat_logs" directory if it does not exist, starts the ChatRoom process,
  and enters the main command loop.
  """
  def start do
    File.mkdir_p("chat_logs")
    {:ok, chat_room} = ChatRoom.start_link()

    loop(chat_room, %{})
  end


  @doc false
  defp loop(chat_room, users) do
    IO.puts("Commands: join <name>, message <name> <msg>, leave <name>, exit")
    user_input = IO.gets("> ") |> String.trim()
    handle_command(user_input, chat_room, users)
  end

  @doc false
  defp handle_command(input, chat_room, users) do
    case parse_command(input) do
      {:join, name} ->
        {:ok, pid} = User.start_link(name, chat_room)
        loop(chat_room, Map.put(users, name, pid))

      {:message, name, message} ->
        pid = Map.fetch!(users, name)
        User.post_message(pid, message)
        loop(chat_room, users)

      {:leave, name} ->
        pid = Map.fetch!(users, name)
        User.stop(pid)
        loop(chat_room, Map.delete(users, name))

      :exit ->
        Enum.each(users, fn {_name, pid} -> User.stop(pid) end)
        :ok

      :unknown ->
        IO.puts("Unknown command")
        loop(chat_room, users)
    end
  end

  @doc false
  defp parse_command(input) do
    case String.split(input) do
      ["join", name] -> {:join, name}
      ["message", name | message] ->
        {:message, name, Enum.join(message, " ")}
      ["leave", name] -> {:leave, name}
      ["exit"] -> :exit
      _ -> :unknown
    end
  end
end
