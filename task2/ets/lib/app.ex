defmodule App do
  @moduledoc """
  The entry point of the Chat Room application.
  Initializes the chat room and handles command line interactions.
  """

  @doc """
  Initializes the chat room and starts the CLI loop for command processing.
  """
  def start do
    # Initializes the ChatRoom, setting up any necessary resources.
    ChatRoom.init()
    IO.puts("Chat Room CLI started.")
    loop()
  end

  # Continuously prompts the user for commands and processes them.
  defp loop do
    IO.puts("Commands: join <name>, leave <name>, exit")
    user_input = IO.gets("> ") |> String.trim()
    handle_command(user_input)
  end

  @doc false
  # Processes the user input and executes the corresponding actions.
  defp handle_command(input) do
    case parse_command(input) do
      {:join, name} ->
        # Handles the logic for a user joining the chat room.
        ChatRoom.create_user(name)
        IO.puts("#{name} has joined the chat room.")
        loop()

      {:leave, name} ->
        # Handles the logic for a user leaving the chat room.
        ChatRoom.delete_user(name)
        IO.puts("#{name} has left the chat room.")
        loop()

      :exit ->
        # Exits the CLI loop and shuts down the chat room interface.
        IO.puts("Exiting chat room.")
        :ok

      :unknown ->
        # Handles unrecognized commands.
        IO.puts("Unknown command")
        loop()
    end
  end

  @doc false
  # Parses the user input into a command tuple.
  defp parse_command(input) do
    case String.split(input) do
      ["join", name] -> {:join, name}
      ["leave", name] -> {:leave, name}
      ["exit"] -> :exit
      _ -> :unknown
    end
  end
end
