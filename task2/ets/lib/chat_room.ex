defmodule ChatRoom do
  @moduledoc """
  Manages the chat room, including user creation, deletion, and retrieval.
  Utilizes ETS for storing user information.
  """

  # Initializes the chat room, setting up necessary resources.
  def init do
    # Creates an ETS table for users, allowing unique entries (:set).
    :ets.new(:users, [:named_table, :public, :set])
    # Initializes the Inbox, setting up any required state or resources.
    Inbox.init()
  end

  @doc """
  Creates a new chat user.

  ## Parameters:
  - name: The name of the user to create.

  ## Returns:
  - The PID tuple {send_pid, receive_pid} of the created user processes.
  """
  def create_user(name) do
    # Start a new chat user and retrieve their process information.
    user_info = ChatUser.start_user(name)
    # Insert the user's name and process information into the ETS table.
    :ets.insert(:users, {name, {user_info.send_pid, user_info.receive_pid}})
  end

  @doc """
  Deletes a chat user by name.

  ## Parameters:
  - name: The name of the user to delete.

  ## Returns:
  - :ok if the user was successfully deleted.
  - {:error, :not_found} if the user does not exist.
  """
  def delete_user(name) do
    case :ets.take(:users, name) do
      [{^name, {send_pid, receive_pid}}] ->
        # If the user exists, kill their send and receive processes.
        Process.exit(send_pid, :kill)
        Process.exit(receive_pid, :kill)
        :ok
      _ ->
        # Return an error if the user could not be found.
        {:error, :not_found}
    end
  end

  @doc """
  Retrieves the names of all active users in the chat room.

  ## Returns:
  - A list of active user names.
  """
  def get_all_users do
    # Converts the ETS table to a list and extracts just the user names.
    :ets.tab2list(:users)
    |> Enum.map(fn {name, _} -> name end)
  end
end
