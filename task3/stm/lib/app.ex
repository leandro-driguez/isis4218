defmodule App do
  @moduledoc """
  Defines the main application interface for interacting with the chat system.
  It initializes the system, starts necessary services, and handles user commands.
  """

  @doc """
  Starts the application, ensuring all necessary services are up and running.
  Continues with initializing the chat system and enters the command loop.
  """
  def start do
    ensure_mnesia_started()
    Chat.start()
    command_loop()
  end

  @doc false
  defp ensure_mnesia_started do
    case Application.ensure_all_started(:mnesia) do
      {:ok, _} -> :ok
      {:error, {:already_started, :mnesia}} -> :ok
      {:error, _} = error -> raise "Failed to start Mnesia: #{inspect(error)}"
    end
  end

  @doc false
  defp command_loop do
    IO.puts("Commands: join <name>, leave <name>, exit")
    IO.gets("> ")
    |> String.trim()
    |> handle_command()
  end

  @doc false
  defp handle_command("join " <> name) do
    name
    |> User.create_user()
    |> Chat.add_user()

    IO.puts("#{name} has joined the chat room.")
    command_loop()
  end

  @doc false
  defp handle_command("leave " <> name) do
    Chat.user_delete(name)
    IO.puts("#{name} has left the chat room.")
    command_loop()
  end

  @doc false
  defp handle_command("exit") do
    IO.puts("Exiting chat room.")
  end

  @doc false
  defp handle_command(_unknown) do
    IO.puts("Unknown command.")
    command_loop()
  end
end
