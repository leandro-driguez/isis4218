defmodule Inbox do
  @moduledoc """
  Handles storing and retrieving messages for users in a concurrent environment.
  Utilizes ETS for storage and a Mutex for concurrency control.
  """

  # Initializes the Inbox, creating an ETS table and starting a Supervisor with a Mutex.
  def init do
    # Creates an ETS table named :inbox, with :bag option to allow duplicate entries for the same key.
    :ets.new(:inbox, [:named_table, :public, :bag])

    # Defines a child process for the Mutex, used to control access to the :inbox table.
    children = [{Mutex, name: :inbox_mutex}]

    # Starts a Supervisor to monitor the Mutex child process.
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
  end

  @doc """
  Inserts a message for a given user into the inbox.

  ## Parameters:
  - user_name: The user's name as an atom.
  - message: The message to insert.
  """
  def insert_message(user_name, message) do
    # Acquires a lock on the :inbox_mutex for the given user_name before inserting a message.
    lock = Mutex.await(:inbox_mutex, user_name)

    # Inserts the message into the :inbox table.
    :ets.insert(:inbox, {user_name, message})

    # Releases the lock after inserting the message.
    Mutex.release(:inbox_mutex, lock)
  end

  @doc """
  Retrieves and deletes all messages for a given user from the inbox.

  ## Parameters:
  - user_name: The user's name as an atom.

  ## Returns:
  A list of messages for the user, in the order they were received.
  """
  def get_messages(user_name) do
    # Acquires a lock on the :inbox_mutex for the given user_name before fetching messages.
    lock = Mutex.await(:inbox_mutex, user_name)

    # Retrieves all messages for the user and deletes them from the :inbox table.
    messages = :ets.lookup(:inbox, user_name) |> Enum.map(&elem(&1, 1))
    :ets.delete(:inbox, user_name)

    # Reverses the list of messages to return them in the order they were received.
    messages = Enum.reverse(messages)

    # Releases the lock after fetching and deleting the messages.
    Mutex.release(:inbox_mutex, lock)

    messages
  end
end
